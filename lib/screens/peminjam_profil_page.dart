import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeminjamProfilPage extends StatefulWidget {
  const PeminjamProfilPage({super.key});

  @override
  State<PeminjamProfilPage> createState() => _PeminjamProfilPageState();
}

class _PeminjamProfilPageState extends State<PeminjamProfilPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ================= Load data user dari tabel 'users' =================
  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final data = await Supabase.instance.client
            .from('users')
            .select()
            .eq('id', user.id)
            .maybeSingle(); // <-- jangan pake .execute()

        if (data != null) {
          setState(() {
            namaController.text = data['nama'] ?? '';
            emailController.text = data['username'] ?? '';
            loading = false;
          });
        } else {
          setState(() => loading = false);
        }
      } catch (e) {
        setState(() => loading = false);
        print("Error load user: $e");
      }
    } else {
      setState(() => loading = false);
    }
  }

  // ================= Simpan perubahan ke Supabase =================
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final updates = {
      'nama': namaController.text,
      'username': emailController.text,
    };

    try {
      final response = await Supabase.instance.client
          .from('users')
          .update(updates)
          .eq('id', user.id)
          .maybeSingle(); // <-- jangan pake .execute()

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 247, 242),
      appBar: AppBar(
        title: const Text('Profil Peminjam'),
        backgroundColor: const Color(0xff01386C),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ================= Avatar =================
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xffD0E6FF),
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(0xff01386C),
                        child: Icon(Icons.person, color: Colors.white, size: 60),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ================= Nama =================
                    TextFormField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon:
                            const Icon(Icons.person, color: Color(0xff01386C)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Nama tidak boleh kosong'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // ================= Email / Username =================
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon:
                            const Icon(Icons.email, color: Color(0xff01386C)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) => value == null || !value.contains('@')
                          ? 'Email tidak valid'
                          : null,
                    ),
                    const SizedBox(height: 30),

                    // ================= Button Simpan =================
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff01386C),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          color: Color(0xffFFD700),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ================= Logout =================
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Supabase.instance.client.auth.signOut();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
