import 'package:flutter/material.dart';

class PetugasDashboard extends StatefulWidget {
  const PetugasDashboard({super.key});

  @override
  State<PetugasDashboard> createState() => _PetugasDashboardState();
}

class _PetugasDashboardState extends State<PetugasDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text('Ini Halaman Beranda', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Ini Halaman Pratinjau', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Ini Halaman Laporan', style: TextStyle(fontSize: 24))),
  ];

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        centerTitle: true,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Pratinjau'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Laporan'),
        ],
      ),
    );
  }
}
