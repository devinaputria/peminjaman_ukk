import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Peminjaman')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Dipinjam', style: TextStyle(fontWeight: FontWeight.bold)),
          Card(
            child: ListTile(
              title: const Text('Mesin Gerinda'),
              subtitle: const Text('Status: Dipinjam'),
            ),
          ),

          const SizedBox(height: 16),

          const Text('Dikembalikan', style: TextStyle(fontWeight: FontWeight.bold)),
          Card(
            child: ListTile(
              title: const Text('Mesin Bor'),
              subtitle: const Text('Status: Dikembalikan'),
            ),
          ),
        ],
      ),
    );
  }
}


 