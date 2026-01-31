import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> riwayat = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
    listenRealtime();
  }

  Future<void> fetchRiwayat() async {
    setState(() => loading = true);
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await supabase
          .from('log_aktivitas')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      riwayat = List<Map<String, dynamic>>.from(response);
      if (!mounted) return;
      setState(() => loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal load riwayat: $e')));
    }
  }

  void listenRealtime() {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    supabase.from('log_aktivitas')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .listen((data) {
      if (!mounted) return;
      setState(() {
        riwayat = List<Map<String, dynamic>>.from(data);
      });
    });
  }

  String formatTanggal(String? tgl) {
    if (tgl == null) return '-';
    try {
      return DateTime.parse(tgl).toLocal().toString().substring(0, 16);
    } catch (e) {
      return tgl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Aktivitas'),
        backgroundColor: const Color(0xFF2A5191),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : riwayat.isEmpty
              ? const Center(child: Text('Belum ada riwayat aktivitas'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: riwayat.length,
                  itemBuilder: (_, i) {
                    final item = riwayat[i];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF2A5191),
                          child: Icon(Icons.history, color: Colors.white),
                        ),
                        title: Text(
                          item['aktivitas'] ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle:
                            Text(formatTanggal(item['created_at']?.toString())),
                      ),
                    );
                  },
                ),
    );
  }
}
