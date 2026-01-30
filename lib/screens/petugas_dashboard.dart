import 'package:flutter/material.dart';
import 'petugas_beranda_page.dart';
import 'petugas_pratinjau_page.dart';
import 'petugas_laporan_page.dart';

class PetugasDashboard extends StatefulWidget {
  const PetugasDashboard({super.key});

  @override
  State<PetugasDashboard> createState() => _PetugasDashboardState();
}

class _PetugasDashboardState extends State<PetugasDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PetugasBerandaPage(),
    const PetugasPratinjauPage(),
    const PetugasLaporanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Pratinjau'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Laporan'),
        ],
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Beranda';
      case 1:
        return 'Pratinjau';
      case 2:
        return 'Laporan';
      default:
        return '';
    }
  }
}
