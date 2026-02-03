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
      backgroundColor: const Color.fromARGB(255, 248, 247, 242),

      appBar: AppBar(
        backgroundColor: const Color(0xFF2A5191),
        centerTitle: true,
        elevation: 2,
        title: const Text(
          'Edit Master Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 8),

            const Text(
              'Kelola data utama aplikasi',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            // ===== GRID MENU =====
            Expanded(
              child: GridView.builder(
                itemCount: menus.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),

                itemBuilder: (context, i) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              menus[i]['page'] as Widget,
                        ),
                      );
                    },

                    child: Card(
                      elevation: 3,
                      shadowColor: Colors.black12,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          // ===== ICON BOX =====
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A5191)
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              menus[i]['icon'] as IconData,
                              size: 42,
                              color: const Color(0xFF2A5191),
                            ),
                          ),

                          const SizedBox(height: 14),

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
      ),
    );
  }
}
