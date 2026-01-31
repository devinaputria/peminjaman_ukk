import 'package:flutter/material.dart';

class PetugasBerandaPage extends StatelessWidget {
  const PetugasBerandaPage({super.key});

  // Dummy data peminjaman
  final List<Map<String, String>> dataPeminjaman = const [
    {
      'nama': 'Andi',
      'kelas': 'XII RPL 1',
      'alat': 'Mesin Bor',
      'kategori': 'Mesin',
      'status': 'menunggu'
    },
    {
      'nama': 'Budi',
      'kelas': 'XII RPL 2',
      'alat': 'Mesin Bubut',
      'kategori': 'Mesin',
      'status': 'disetujui'
    },
    {
      'nama': 'Cici',
      'kelas': 'XII RPL 3',
      'alat': 'Sarung Tangan',
      'kategori': 'Safety',
      'status': 'ditolak'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dataPeminjaman.length,
      itemBuilder: (context, index) {
        final item = dataPeminjaman[index];

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama + Kelas
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['nama']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          item['kelas']!,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                // Alat & Kategori
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                        avatar: const Icon(Icons.build, size: 18),
                        label: Text(item['alat']!),
                        backgroundColor: Colors.blue.shade50),
                    Chip(
                        avatar: const Icon(Icons.category, size: 18),
                        label: Text(item['kategori']!),
                        backgroundColor: Colors.blue.shade50),
                  ],
                ),
                const SizedBox(height: 16),
                // Status
                Text(
                  'Status: ${item['status']!.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
