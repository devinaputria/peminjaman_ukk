import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    setState(() => loading = true);
    try {
      final data = await supabase.from('users').select();
      setState(() {
        users = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print('Error fetch users: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil data users')),
      );
    }
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

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(user == null ? 'Tambah User' : 'Edit User'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Username tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Role tidak boleh kosong' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          ElevatedButton(
            child: const Text('Simpan'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(user == null
                          ? 'User berhasil ditambah'
                          : 'User berhasil diupdate'),
                    ),
                  );
                } catch (e) {
                  print('Error simpan user: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menyimpan user')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  // === DELETE ===
  Future<void> deleteUser(dynamic id) async {
    try {
      await supabase.from('users').delete().eq('id', id);
      fetchUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User berhasil dihapus')),
      );
    } catch (e) {
      print('Error delete user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus user')),
      );
    }
  }

  // === UI ===
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
