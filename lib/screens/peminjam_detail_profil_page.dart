import 'package:flutter/material.dart';

class PeminjamProfilDetailPage extends StatefulWidget {
  const PeminjamProfilDetailPage({super.key});

  @override
  State<PeminjamProfilDetailPage> createState() =>
      _PeminjamProfilDetailPageState();
}

class _PeminjamProfilDetailPageState
    extends State<PeminjamProfilDetailPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController =
      TextEditingController(text: 'Devina Putri Aurellia');
  final TextEditingController emailController =
      TextEditingController(text: 'devina@gmail.com');
  final TextEditingController telpController =
      TextEditingController(text: '08123456789');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail & Edit Profil'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),

              const CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),

              const SizedBox(height: 20),

              // NAMA
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // EMAIL
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // TELEPON
              TextFormField(
                controller: telpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No Telepon',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length < 10) {
                    return 'No telepon tidak valid';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // BUTTON SIMPAN
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profil berhasil diperbarui'),
                      ),
                    );
                  }
                },
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
