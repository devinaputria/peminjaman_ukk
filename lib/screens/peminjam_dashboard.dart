import 'package:flutter/material.dart';
import 'peminjam_riwayat_page.dart';
import 'peminjam_beranda_page.dart';
import 'peminjam_alat_page.dart';
import 'peminjam_peminjaman_page.dart';
import 'peminjam_profil_page.dart';
import '../widgets/peminjam_bottom_nav.dart'; // import navbar

class PeminjamDashboard extends StatefulWidget {
  const PeminjamDashboard({super.key});

  @override
  State<PeminjamDashboard> createState() => _PeminjamDashboardState();
}

class _PeminjamDashboardState extends State<PeminjamDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PeminjamBerandaPage(),
    const AlatPage(),             // halaman alat
    const PeminjamanPage(selectedAlat: []), // halaman peminjaman
    const PeminjamRiwayatPage(),  // halaman riwayat
    const PeminjamProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Peminjam'),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: PeminjamBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
