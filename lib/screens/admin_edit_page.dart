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

    return Container(
      color: const Color(0xFFFFF8E7), // cream background
      child: Column(
        children: [
          const SizedBox(height: 20), // jarak atas agar tidak mepet
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Master Data',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Kelola data utama aplikasi',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

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
                          color: const Color(0xFF2A5191), // biru konsisten
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
