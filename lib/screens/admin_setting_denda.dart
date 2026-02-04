import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminSettingDendaPage extends StatefulWidget {
  const AdminSettingDendaPage({super.key});

  @override
  State<AdminSettingDendaPage> createState() => _AdminSettingDendaPageState();
}

class _AdminSettingDendaPageState extends State<AdminSettingDendaPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> alatList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchAlat();
  }

  // ================= FETCH DATA ALAT =================
  Future<void> fetchAlat() async {
    setState(() => loading = true);
    try {
      final data = await supabase.from('alat').select('*').order('nama_mesin');
      if (!mounted) return;
      setState(() {
        alatList = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

  // ================= UPDATE DENDA PERHARI =================
  Future<void> updateDenda(int alatId, int denda) async {
    try {
      await supabase
          .from('alat')
          .update({'denda': denda})
          .eq('id', alatId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil memperbarui denda')),
      );

      fetchAlat();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update: $e')),
      );
    }
  }

  // ================= DIALOG INPUT DENDA =================
  void openDendaDialog(Map<String, dynamic> alat) {
    // Kalau denda null tampilkan 0, tapi admin bisa ubah
    final controller = TextEditingController(
      text: (alat['denda'] ?? "").toString(),
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Denda Per Hari',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2A5191),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Denda per hari (Rp)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        final denda = int.tryParse(controller.text) ?? 0;
                        updateDenda(alat['id'], denda);
                      },
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A5191),
        title: const Text('Setting Denda Per Hari'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : alatList.isEmpty
              ? const Center(child: Text('Belum ada alat'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: alatList.length,
                  itemBuilder: (context, index) {
                    final alat = alatList[index];
                    final denda = alat['denda'] ?? 0;

                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () => openDendaDialog(alat),
                        leading: const Icon(Icons.build, color: Color(0xFF2A5191)),
                        title: Text(
                          alat['nama_mesin'] ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          'Rp $denda/hari',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
