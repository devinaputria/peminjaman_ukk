import 'package:flutter/material.dart';

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF1E40AF),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Peminjaman',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Form Pengajuan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              decoration: InputDecoration(
                labelText: 'Alat',
                hintText: 'Mesin Bor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              decoration: InputDecoration(
                labelText: 'Tanggal Pengembalian',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ================= BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Ajukan Peminjaman',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
