import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'peminjam_detail_profil_page.dart';

class PeminjamProfilPage extends StatelessWidget {
  const PeminjamProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data profil
    const String nama = "Devina Putri Aurellia";
    const String role = "Peminjam";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: const Color(0xff01386C), // Biru
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          // Logo Profil
          const CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xff01386C),
            child: Icon(Icons.person, color: Colors.white, size: 60),
          ),

          const SizedBox(height: 16),

          // Nama
          Text(
            nama,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff01386C),
              decoration: TextDecoration.none,
            ),
          ),

          const SizedBox(height: 8),

          // Role
          Text(
            role,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              decoration: TextDecoration.none,
            ),
          ),

          const SizedBox(height: 30),

          // Detail Profil & Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info, color: Color(0xff01386C)),
                  title: const Text('Detail Profil'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                         builder: (_) => const PeminjamProfilDetailPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout'),
                  onTap: () async {
                    // Logout Supabase
                    await Supabase.instance.client.auth.signOut();

                    // Pindah ke halaman login
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}