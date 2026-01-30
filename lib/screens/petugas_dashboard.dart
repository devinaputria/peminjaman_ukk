import 'package:flutter/material.dart';
import 'package:peminjaman/screens/riwayat_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'peminjam_beranda_page.dart';
import 'peminjam_alat_page.dart';
import 'peminjam_peminjaman_page.dart';
import 'peminjam_riwayat_page.dart';
import 'peminjam_profil_page.dart';
import '../routes/app_routes.dart';


class PeminjamDashboard extends StatefulWidget {
  const PeminjamDashboard({super.key});

  @override
  State<PeminjamDashboard> createState() => _PeminjamDashboardState();
}

class _PeminjamDashboardState extends State<PeminjamDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PeminjamBerandaPage(),
    const AlatPage(),
    const PeminjamBerandaPage(),
    const RiwayatPage(),
    const PeminjamProfilPage(),
  ];

  // ================= LOGOUT =================
  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ APPBAR UTAMA + LOGOUT
      appBar: AppBar(
        title: Text(_getTitle()),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),

      // ================= BODY =================
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Alat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Peminjaman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // ================= JUDUL APPBAR =================
  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Beranda';
      case 1:
        return 'Alat';
      case 2:
        return 'Peminjaman';
      case 3:
        return 'Riwayat';
      case 4:
        return 'Profil';
      default:
        return '';
    }
  }
}
