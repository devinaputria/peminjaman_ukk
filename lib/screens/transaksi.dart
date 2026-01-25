import 'package:flutter/material.dart';

class TransaksiPage extends StatelessWidget {
  const TransaksiPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi'),backgroundColor: Colors.blue, toolbarHeight: 200,),
      body: const Center(
        child: Text('INI HALAMAN TRANSAKSIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIi', style: TextStyle(fontSize: 32)),
      ),
    );
  }
}