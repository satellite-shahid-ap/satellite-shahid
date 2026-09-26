import 'package:flutter/material.dart';

void main() {
  runApp(const SatelliteShahidApp());
}

class SatelliteShahidApp extends StatelessWidget {
  const SatelliteShahidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ستلايت شاهد',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFFEAB308),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final String jaibAccount = '4444183';
  final String jaibPhone = '777905859';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ستلايت شاهد 📡', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEAB308)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('طريقة الدفع (محفظة جيب):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFEAB308))),
                const SizedBox(height: 8),
                Text('رقم الحساب: $jaibAccount', style: const TextStyle(fontSize: 15)),
                Text('رقم الهاتف: $jaibPhone', style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('باقات VIP 1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildPackageCard(context, 'VIP 1 - 3 أشهر', 9500),
          _buildPackageCard(context, 'VIP 1 - 6 أشهر', 13500),
          _buildPackageCard(context, 'VIP 1 - سنة كاملة', 27000),
          const SizedBox(height: 20),
          const Text('باقات VIP 2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildPackageCard(context, 'VIP 2 - 3 أشهر', 10000),
          _buildPackageCard(context, 'VIP 2 - سنة كاملة', 27000),
        ],
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, String title, int price) {
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$price ريال يمني', style: const TextStyle(color: Color(0xFFEAB308))),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEAB308), foregroundColor: Colors.black),
          child: const Text('طلب الاشتراك'),
          onPressed: () => _openOrderDialog(context, title, price),
        ),
      ),
    );
  }

  void _openOrderDialog(BuildContext context, String title, int price) {
    final serialController = TextEditingController();
    final transferController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text('تأكيد طلب $title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: serialController,
              decoration: const InputDecoration(labelText: 'سيريال الرسيفر', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: transferController,
              decoration: const InputDecoration(labelText: 'رقم عملية حوالة جيب', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('إلغاء', style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEAB308), foregroundColor: Colors.black),
            child: const Text('إرسال الطلب'),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم استلام طلبك وجارٍ مراجعته والتفعيل ✅')),
              );
            },
          ),
        ],
      ),
    );
  }
}
