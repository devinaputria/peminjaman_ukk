//petugas_beranda
import 'package:flutter/material.dart';

class PetugasBerandaPage extends StatelessWidget {
  const PetugasBerandaPage({super.key});

  final List<Map<String, String>> dataDummy = const [
    {
      'nama': 'Andi',
      'kelas': 'XI RPL 1',
      'alat': 'Bor Listrik',
      'kategori': 'Perkakas',
      'status': 'menunggu',
    },
    {
      'nama': 'Siti',
      'kelas': 'XI RPL 2',
      'alat': 'Gergaji',
      'kategori': 'Perkakas',
      'status': 'disetujui',
    },
    {
      'nama': 'Rani',
      'kelas': 'XI RPL 3',
      'alat': 'Helm Safety',
      'kategori': 'Keamanan',
      'status': 'ditolak',
    },
  ];

  Color getWarnaStatus(String status) {
    switch (status) {
      case 'menunggu':
        return Colors.orange;
      case 'disetujui':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dataDummy.length,
      itemBuilder: (context, index) {
        final item = dataDummy[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['nama']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text("Kelas: ${item['kelas']}"),
                Text("Alat: ${item['alat']}"),
                Text("Kategori: ${item['kategori']}"),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getWarnaStatus(item['status']!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item['status']!.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
