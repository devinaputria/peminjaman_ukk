import 'package:flutter/material.dart';

class PeminjamProfilDetailPage extends StatelessWidget {
  const PeminjamProfilDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Profil'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // FOTO
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 55, color: Colors.white),
            ),

            const SizedBox(height: 16),

            // NAMA
            const Text(
              'Devina Putri Aurellia',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              'Peminjam',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // DETAIL DATA
            profileItem(
              icon: Icons.badge,
              label: 'Nama Lengkap',
              value: 'Devina Putri Aurellia',
            ),
            profileItem(
              icon: Icons.school,
              label: 'Kelas',
              value: 'XI TPM 1',
            ),
            profileItem(
              icon: Icons.work,
              label: 'Role',
              value: 'Peminjam',
            ),
            profileItem(
              icon: Icons.phone,
              label: 'No HP',
              value: '08xxxxxxxxxx',
            ),

            const Spacer(),

            // BUTTON EDIT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Edit Profil',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget profileItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
