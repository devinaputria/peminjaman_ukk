import 'package:flutter/material.dart';
import 'detail_peminjaman_page.dart';

class AdminPengembalianPage extends StatelessWidget {
  const AdminPengembalianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _peminjamanItem(
            context,
            nama: 'Depina',
            kelas: 'XI TPM 1',
            alat: 'Mesin Bor',
            status: 'Dipinjam',
          ),
        ],
      ),
    );
  }

  Widget _peminjamanItem(
    BuildContext context, {
    required String nama,
    required String kelas,
    required String alat,
    required String status,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DetailPeminjamanPage(),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(kelas),
                    Text('Alat: $alat'),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
