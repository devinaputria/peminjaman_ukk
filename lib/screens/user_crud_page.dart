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
  String selectedRole = 'Peminjam';

  final List<String> roles = ['Peminjam', 'Petugas', 'Admin'];

  // ================= TAMBAH / EDIT USER =================
  void showUserForm({int? index}) {
    if (index != null) {
      namaController.text = users[index]['nama']!;
      selectedRole = users[index]['role']!;
    } else {
      namaController.clear();
      selectedRole = 'Peminjam';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                index == null ? 'Tambah User' : 'Edit User',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // ===== INPUT NAMA =====
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama User',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // ===== DROPDOWN ROLE =====
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: roles
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedRole = value!);
                },
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // ===== BUTTON =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (index == null) {
                        users.add({
                          'nama': namaController.text,
                          'role': selectedRole,
                        });
                      } else {
                        users[index] = {
                          'nama': namaController.text,
                          'role': selectedRole,
                        };
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        );
      },
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
      backgroundColor: Colors.grey[100],

      // ===== HEADER =====
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manajemen User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Tambah, edit, dan hapus user',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ===== LIST USER =====
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: users.length,
              itemBuilder: (_, index) {
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(Icons.person, color: Colors.blue),
                    ),
                    title: Text(
                      users[index]['nama']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(users[index]['role']!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () =>
                              showUserForm(index: index),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteUser(index),
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

      // ===== FAB =====
      floatingActionButton: FloatingActionButton(
        onPressed: () => showUserForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
