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
        SnackBar(content: Text('Gagal memuat user: $e')),
      );
    }
  }

  // ================= FORM TAMBAH / EDIT =================
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          user == null ? 'Tambah User' : 'Edit User',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: namaController,
                  label: "Nama",
                  icon: Icons.person,
                ),

                const SizedBox(height: 12),

                _buildTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email,
                ),

                const SizedBox(height: 12),

                if (user == null)
                  _buildTextField(
                    controller: passwordController,
                    label: "Password",
                    icon: Icons.lock,
                    isPassword: true,
                  ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: role,
                  decoration: InputDecoration(
                    labelText: "Role",
                    prefixIcon: const Icon(Icons.badge),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: roleList
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(r.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => role = v!),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A5191),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Simpan'),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              try {
                if (user == null) {
                  final auth = await supabase.auth.signUp(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  final userId = auth.user!.id;

                  await supabase.from('user').insert({
                    'id': userId,
                    'nama': namaController.text,
                    'username': emailController.text,
                    'role': role,
                  });
                } else {
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
                    content: Text(
                      user == null
                          ? 'User berhasil ditambah'
                          : 'User berhasil diupdate',
                    ),
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

  // ================= DELETE USER =================
  Future<void> deleteUser(String id) async {
    try {
      await supabase.auth.admin.deleteUser(id);
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
      backgroundColor: const Color(0xFFF2F6FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF2A5191),
        elevation: 0,
        title: const Text(
          'Manajemen User',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2A5191),
        onPressed: () => showForm(),
        icon: const Icon(Icons.person_add),
        label: const Text("Tambah User"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (_, i) {
                final user = users[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    leading: CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFF2A5191),
                      child: Text(
                        user['nama'][0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    title: Text(
                      user['nama'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user['username'] ?? ''),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF2A5191).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user['role'].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF2A5191),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.orange),
                          onPressed: () => showForm(user: user),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.red),
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

  // ========== COMPONENT TEXTFIELD ==========
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (v) =>
          v == null || v.isEmpty ? '$label wajib diisi' : null,
    );
  }
}
