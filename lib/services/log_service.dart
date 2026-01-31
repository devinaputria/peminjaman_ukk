import 'package:supabase_flutter/supabase_flutter.dart';

class LogService {
  final supabase = Supabase.instance.client;

  // Tambah log otomatis
  Future<void> tambahLog(String aktivitas) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('log_aktivitas').insert({
        'user_id': user.id,
        'aktivitas': aktivitas,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Gagal menambahkan log: $e');
    }
  }
}
