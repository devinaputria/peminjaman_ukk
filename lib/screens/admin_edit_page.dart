import 'package:flutter/material.dart';
import 'package:peminjaman/screens/user_crud_page.dart';
import 'package:peminjaman/screens/alat_crud_page.dart';
import 'package:peminjaman/screens/kategori_crud_page.dart';

class EditMenuScreen extends StatelessWidget {
  const EditMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      {
        'icon': Icons.people,
        'label': 'User',
        'page': const UserCrudPage(),
      },
      {
        'icon': Icons.hardware,
        'label': 'Alat',
        'page': const AlatCrudPage(),
      },
      {
        'icon': Icons.category,
        'label': 'Kategori',
        'page': const KategoriCrudPage(),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // ===== HEADER =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Edit Master Data',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Kelola data utama aplikasi',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===== GRID MENU =====
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: menus.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, i) {
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => menus[i]['page'] as Widget,
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          menus[i]['icon'] as IconData,
                          size: 48,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          menus[i]['label'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
