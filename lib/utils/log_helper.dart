import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> tambahLog(String aktivitas) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;
  if (user == null) return;

  try {
    await supabase.from('log_aktivitas').insert({
      'user_id': user.id,
      'aktivitas': aktivitas,
      'created_at': DateTime.now().toIso8601String(),
    });
  } catch (e) {
    print('Gagal tambah log: $e');
  }
}
