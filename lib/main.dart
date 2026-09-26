import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const SatelliteApp());
}

class SatelliteApp extends StatelessWidget {
  const SatelliteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ستلايت شاهد',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFFEAB308),
        fontFamily: 'sans-serif',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // رقم صاحب التطبيق / الموزع لاستقبال الطلبات
  final String vendorPhone = '967777905859';

  Future<void> sendOrderToWhatsApp(BuildContext context, String plan, String serial, String txId) async {
    final message = '''
طلب اشتراك جديد 🛰️
الباقة: $plan
سيريال الرسيفر: $serial
رقم عملية جيب: $txId
''';

    // رابط مباشر ومتوافق لفتح محادثة صاحب التطبيق في واتساب
    final url = "https://api.whatsapp.com/send?phone=$vendorPhone&text=${Uri.encodeComponent(message)}";
    final uri = Uri.parse(url);

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح واتساب، يرجى التأكد من تثبيته في هاتفك')),
        );
      }
    }
  }

  void showOrderDialog(BuildContext context, String planName) {
    final serialController = TextEditingController();
    final txController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('تأكيد طلب $planName', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: serialController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'سيريال الرسيفر',
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: txController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'رقم عملية حوالة جيب',
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEAB308),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              if (serialController.text.trim().isEmpty || txController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يرجى تعبئة كافة الحقول')),
                );
                return;
              }
              Navigator.pop(ctx);
              sendOrderToWhatsApp(context, planName, serialController.text.trim(), txController.text.trim());
            },
            child: const Text('إرسال الطلب', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ستلايت شاهد 🛰️', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEAB308), width: 1.5),
              ),
              child: const Column(
                children: [
                  Text('طريقة الدفع (محفظة جيب):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFEAB308))),
                  SizedBox(height: 8),
                  Text('رقم الحساب: 4444183', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 4),
                  Text('رقم الهاتف: 777905859', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('باقات VIP 1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildPlanCard(context, 'VIP 1 - 3 أشهر', '9500 ريال يمني'),
            buildPlanCard(context, 'VIP 1 - 6 أشهر', '13500 ريال يمني'),
            buildPlanCard(context, 'VIP 1 - سنة كاملة', '27000 ريال يمني'),
            const SizedBox(height: 20),
            const Text('باقات VIP 2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            buildPlanCard(context, 'VIP 2 - 3 أشهر', '10000 ريال يمني'),
            buildPlanCard(context, 'VIP 2 - سنة كاملة', '27000 ريال يمني'),
          ],
        ),
      ),
    );
  }

  Widget buildPlanCard(BuildContext context, String title, String price) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(price, style: const TextStyle(color: Color(0xFFEAB308))),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEAB308),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () => showOrderDialog(context, title),
          child: const Text('طلب الاشتراك', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}


