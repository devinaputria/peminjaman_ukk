import 'package:flutter/material.dart';
import '../widgets/peminjam_bottom_nav.dart'; // <- path fix
import 'peminjam_beranda_page.dart';
import 'peminjam_alat_page.dart';
import 'peminjam_peminjaman_page.dart';
import 'peminjam_riwayat_page.dart';
import 'peminjam_profil_page.dart';

class PeminjamDashboardPage extends StatefulWidget {
  const PeminjamDashboardPage({super.key});

  @override
  State<PeminjamDashboardPage> createState() =>
      _PeminjamDashboardPageState();
}

class _PeminjamDashboardPageState extends State<PeminjamDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PeminjamBerandaPage(),
    const AlatPage(),
    const PeminjamanPage(selectedAlat: []), // <- fix parameter
    const PeminjamRiwayatPage(),
    const PeminjamProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
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
