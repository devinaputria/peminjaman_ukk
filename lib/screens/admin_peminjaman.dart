import 'package:flutter/material.dart';
import 'detail_peminjaman_page.dart';

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ============ INI YANG KAMU MINTA =============
      backgroundColor: const Color.fromARGB(255, 248, 247, 242),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          peminjamanItem(context),
        ],
      ),
    );
  }

  Widget peminjamanItem(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // 👉 PINDAH KE DETAIL (TETAP SAMA – TIDAK DIUBAH)
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
        elevation: 2,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                child: Icon(Icons.person),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Depina',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'XI TPM 1',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              Column(
                children: const [
                  Text(
                    'Dipinjam',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6),

                  Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
