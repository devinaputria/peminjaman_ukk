import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class UserCrudPage extends StatefulWidget {
  const UserCrudPage({super.key});

  @override
  State<UserCrudPage> createState() => _UserCrudPageState();
}

class _UserCrudPageState extends State<UserCrudPage> {
  final supabase = Supabase.instance.client;

  List users = [];
  bool loading = true;

  final namaController = TextEditingController();
  final usernameController = TextEditingController();
  final roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // ================= GET =================
  Future<void> fetchUsers() async {
    final data = await supabase.from('users').select();
    setState(() {
      users = data;
      loading = false;
    });
  }

  // ================= INSERT & UPDATE =================
  void showForm({Map? user}) {
    if (user != null) {
      namaController.text = user['nama'];
      usernameController.text = user['username'];
      roleController.text = user['role'];
    } else {
      namaController.clear();
      usernameController.clear();
      roleController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(user == null ? 'Tambah User' : 'Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama')),
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: roleController, decoration: const InputDecoration(labelText: 'Role')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            child: const Text('Simpan'),
            onPressed: () async {
              if (user == null) {
                await supabase.from('users').insert({
                  'nama': namaController.text,
                  'username': usernameController.text,
                  'role': roleController.text,
                });
              } else {
                await supabase.from('users').update({
                  'nama': namaController.text,
                  'username': usernameController.text,
                  'role': roleController.text,
                }).eq('id', user['id']);
              }

              Navigator.pop(context);
              fetchUsers();
            },
          ),
        ],
      ),
    );
  }

  // ================= DELETE =================
  Future<void> deleteUser(String id) async {
    await supabase.from('users').delete().eq('id', id);
    fetchUsers();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD User'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (_, i) {
                final user = users[i];
                return Card(
                  child: ListTile(
                    title: Text(user['nama']),
                    subtitle: Text('Role: ${user['role']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => showForm(user: user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteUser(user['id']),
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
