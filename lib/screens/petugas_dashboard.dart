import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'petugas_beranda_page.dart';
import 'petugas_pratinjau_page.dart';
import 'petugas_laporan_page.dart';
import '../routes/app_routes.dart';

class PetugasDashboard extends StatefulWidget {
  const PetugasDashboard({super.key});

  @override
  State<PetugasDashboard> createState() => _PetugasDashboardState();
}

class _PetugasDashboardState extends State<PetugasDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PetugasBerandaPage(),
    PetugasPratinjauPage(),
    PetugasLaporanPage(),
  ];

  // ================= LOGOUT =================
  Future<void> logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  // ================= APPBAR CUSTOM =================
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(176),
      child: Container(
        height: 176, // ⭐ INI YANG DITAMBAHKAN
        decoration: const BoxDecoration(
          color: Color(0xFF1E40AF),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.build_circle,
                  color: Colors.white,
                  size: 30,
                ),
                const Text(
                  'Dashboard Petugas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () => logout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: const Color(0xFF1E40AF),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.preview),
            label: 'Pratinjau',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Laporan',
          ),
        ],
      ),
    );
  }
}
