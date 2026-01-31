import 'package:flutter/material.dart';

class UserCrudPage extends StatefulWidget {
  const UserCrudPage({super.key});

  @override
  State<UserCrudPage> createState() => _UserCrudPageState();
}

class _UserCrudPageState extends State<UserCrudPage> {
  List<Map<String, dynamic>> users = [
    {'id': 1, 'nama': 'Devina', 'role': 'Admin'},
    {'id': 2, 'nama': 'vina', 'role': 'Peminjam'},
  ];

  bool loading = false;
  bool connected = true; // dummy connected

  final namaController = TextEditingController();
  final roleController = TextEditingController();

  // ================= INSERT & UPDATE =================
  void showForm({Map<String, dynamic>? user}) {
    if (user != null) {
      namaController.text = user['nama'];
      roleController.text = user['role'];
    } else {
      namaController.clear();
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  if (user == null) {
                    users.add({
                      'id': users.isEmpty ? 1 : users.last['id'] + 1,
                      'nama': namaController.text,
                      'role': roleController.text,
                    });
                  } else {
                    user['nama'] = namaController.text;
                    user['role'] = roleController.text;
                  }
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(user == null
                        ? 'User berhasil ditambah'
                        : 'User berhasil diupdate'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ================= DELETE =================
  void deleteUser(Map<String, dynamic> user) {
    setState(() {
      users.removeWhere((u) => u['id'] == user['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User berhasil dihapus')),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('CRUD User'),
            const Spacer(),
            Icon(
              connected ? Icons.check_circle : Icons.error,
              color: connected ? Colors.greenAccent : Colors.redAccent,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              connected ? 'Connected' : 'Disconnected',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
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
                          onPressed: () => deleteUser(user),
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
