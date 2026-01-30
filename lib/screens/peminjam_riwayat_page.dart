import 'package:flutter/material.dart';

class PeminjamRiwayatPage extends StatelessWidget {
  const PeminjamRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Peminjaman'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Riwayat masih kosong',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
