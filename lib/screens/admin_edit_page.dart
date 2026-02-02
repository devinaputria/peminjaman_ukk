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
      appBar: AppBar(
        title: const Text(
          'Edit Master Data',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2A5191), // tetap biru
        elevation: 4,
        automaticallyImplyLeading: false, // hentikan back button otomatis
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // tombol kembali manual
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Tambahkan aksi logout
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 248, 247, 242), // cream
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Kelola data utama aplikasi',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // ===== GRID MENU =====
            Expanded(
              child: GridView.builder(
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
                            color: const Color(0xFF2A5191),
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
      ),
    );
  }
}