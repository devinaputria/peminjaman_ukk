import 'package:flutter/material.dart';

class UserCrudPage extends StatefulWidget {
  const UserCrudPage({super.key});

  @override
  State<UserCrudPage> createState() => _UserCrudPageState();
}

class _UserCrudPageState extends State<UserCrudPage> {
  // ================= DATA DUMMY USER =================
  final List<Map<String, String>> users = [
    {'nama': 'Andi', 'role': 'Peminjam'},
    {'nama': 'Budi', 'role': 'Petugas'},
    {'nama': 'Admin', 'role': 'Admin'},
  ];

  // ================= FORM CONTROLLER =================
  final TextEditingController namaController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  // ================= TAMBAH / EDIT USER =================
  void showUserForm({int? index}) {
    if (index != null) {
      namaController.text = users[index]['nama']!;
      roleController.text = users[index]['role']!;
    } else {
      namaController.clear();
      roleController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(index == null ? 'Tambah User' : 'Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (index == null) {
                  users.add({
                    'nama': namaController.text,
                    'role': roleController.text,
                  });
                } else {
                  users[index] = {
                    'nama': namaController.text,
                    'role': roleController.text,
                  };
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // ================= HAPUS USER =================
  void deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD User'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showUserForm(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (_, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(users[index]['nama']!),
              subtitle: Text('Role: ${users[index]['role']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => showUserForm(index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUser(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
