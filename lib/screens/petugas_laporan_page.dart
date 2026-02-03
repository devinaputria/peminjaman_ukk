//laporan petugas
import 'package:flutter/material.dart';

class PetugasLaporanPage extends StatelessWidget {
  const PetugasLaporanPage({super.key});

  final List<Map<String, String>> laporan = const [
    {'barang': 'Mesin Bor', 'peminjam': 'Andi', 'status': 'Dipinjam'},
    {'barang': 'Gerinda', 'peminjam': 'Budi', 'status': 'Dipinjam'},
    {'barang': 'Obeng Set', 'peminjam': 'Cici', 'status': 'Dikembalikan'},
  ];

  Color warnaStatus(String status) {
    return status == "Dipinjam"
        ? Colors.orange.shade100
        : Colors.green.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: laporan.length,
      itemBuilder: (context, index) {
        final data = laporan[index];

        return Card(
          child: ListTile(
            //  LOGO
            leading: const CircleAvatar(
              backgroundColor: Color(0xff01386C),
              child: Icon(Icons.person, color: Colors.white),
            ),

            title: Text(
              data['barang']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            subtitle: Text("Dipinjam oleh: ${data['peminjam']}"),

            trailing: Chip(
              label: Text(data['status']!),
              backgroundColor: warnaStatus(data['status']!),
            ),
          ),
        );
      },
    );
  }
}
