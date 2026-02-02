//dashboard petugas
import 'package:flutter/material.dart';
import 'petugas_beranda_page.dart';
import 'petugas_pratinjau_page.dart';
import 'petugas_laporan_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetugasDashboard extends StatefulWidget {
  const PetugasDashboard({super.key});

  @override
  State<PetugasDashboard> createState() => _PetugasDashboardState();
}

class _PetugasDashboardState extends State<PetugasDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    PetugasBerandaPage(),
    PetugasPratinjauPage(),
    PetugasLaporanPage(),
  ];

  String getTitle() {
    switch (_currentIndex) {
      case 0:
        return "Beranda";
      case 1:
        return "Pratinjau";
      case 2:
        return "Laporan";
      default:
        return "";
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff01386C),
        title: Text(getTitle()),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          // LOGO PROFIL
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Menu Profil (belum dibuat)")),
              );
            },
          ),

          // LOGOUT
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),

      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xff01386C),
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Pratinjau"),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: "Laporan"),
        ],
      ),
    );
  }
}
