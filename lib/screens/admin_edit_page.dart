import 'package:flutter/material.dart';
import 'package:peminjaman/screens/user_crud_page.dart';
import 'package:peminjaman/screens/alat_crud_page.dart';
import 'package:peminjaman/screens/kategori_crud_page.dart';


class EditMenuScreen extends StatelessWidget {
  const EditMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      {'icon': Icons.people, 'label': 'User'},
      {'icon': Icons.hardware, 'label': 'Alat'},
      {'icon': Icons.category, 'label': 'Kategori'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Master'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        toolbarHeight: 200,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: menus.length,
        itemBuilder: (context, i) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                menus[i]['icon'] as IconData,
                size: 28,
                color: Colors.blue,
              ),
              title: Text(
                menus[i]['label'] as String,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.chevron_right, size: 28),
              onTap: () {
                if (menus[i]['label'] == 'User') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserCrudPage(),
                    ),
                  );
                } else if (menus[i]['label'] == 'Alat') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AlatCrudPage(),
                    ),
                  );
                } else if (menus[i]['label'] == 'Kategori') {
                  Navigator.push(
                    context,
                      MaterialPageRoute(
                        builder: (_) => const KategoriCrudPage()
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
