import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserCrudPage extends StatefulWidget {
  const UserCrudPage({super.key});

  @override
  State<UserCrudPage> createState() => _UserCrudPageState();
}

class _UserCrudPageState extends State<UserCrudPage> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> users = [];
  bool loading = false;

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String role = 'peminjam';

  final List<String> roleList = ['admin', 'petugas', 'peminjam'];

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  // ================= GET USER =================
  Future<void> fetchUser() async {
    setState(() => loading = true);

    try {
      final data = await supabase
          .from('user')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        users = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal load user: $e')),
      );
    }
  }

  // ================= FORM =================
  void showForm({Map<String, dynamic>? user}) {
    if (user != null) {
      namaController.text = user['nama'] ?? '';
      emailController.text = user['username'] ?? '';
      role = user['role'] ?? 'peminjam';
    } else {
      namaController.clear();
      emailController.clear();
      passwordController.clear();
      role = 'peminjam';
    }

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(user == null ? 'Tambah User' : 'Edit User'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Email wajib diisi' : null,
                ),

                const SizedBox(height: 10),

                // PASSWORD HANYA SAAT TAMBAH
                if (user == null)
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) => v == null || v.length < 6
                        ? 'Minimal 6 karakter'
                        : null,
                  ),

                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  value: role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: roleList.map((r) {
                    return DropdownMenuItem(
                      value: r,
                      child: Text(r.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      role = v!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),

          ElevatedButton(
            child: const Text('Simpan'),

            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              try {
                // ============ TAMBAH USER ============
                if (user == null) {

                  // 1. BUAT AUTH DULU
                  final auth = await supabase.auth.signUp(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  final userId = auth.user!.id;

                  // 2. SIMPAN KE TABEL USER
                  await supabase.from('user').insert({
                    'id': userId,
                    'nama': namaController.text,
                    'username': emailController.text,
                    'role': role,
                  });
                }

                // ============ EDIT USER ============
                else {
                  await supabase.from('user').update({
                    'nama': namaController.text,
                    'username': emailController.text,
                    'role': role,
                  }).eq('id', user['id']);
                }

                Navigator.pop(context);
                fetchUser();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(user == null
                        ? 'User berhasil ditambah'
                        : 'User berhasil diupdate'),
                  ),
                );

              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal simpan: $e')),
                );
              }
            },
          )
        ],
      ),
    );
  }

  // ================= DELETE =================
  Future<void> deleteUser(String id) async {
    try {
      await supabase.from('user').delete().eq('id', id);

      fetchUser();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal hapus: $e')),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= APPBAR MODERN =================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // tinggi AppBar
        child: AppBar(
          backgroundColor: const Color(0xFF2A5191),
          elevation: 4,
          centerTitle: true,
          title: const Text(
            'Manajemen User',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      backgroundColor: const Color(0xFFF5F5F5), // ganti background

      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        backgroundColor: const Color(0xFF2A5191),
        child: const Icon(Icons.add),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (_, i) {
                final user = users[i];

                // CARD MODERN
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF2A5191),
                      child: Text(
                        user['nama'] != null && user['nama'].isNotEmpty
                            ? user['nama'][0].toUpperCase()
                            : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      user['nama'] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user['username']}'),
                        Text('Role: ${user['role']}'),
                      ],
                    ),
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
