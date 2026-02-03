import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class PeminjamanService {

  // ================= GET DATA UNTUK PETUGAS BERANDA =================
  static Future<List<Map<String, dynamic>>> getPengajuan() async {
    final response = await supabase
        .from('peminjaman')
        .select('''
          *,
          user:user_id(nama, kelas),
          alat:detail_peminjaman!inner(
            alat:alat_id(nama, kategori:kategori_id(nama))
          )
        ''')
        .eq('status', 'dipinjam');

    return List<Map<String, dynamic>>.from(response);
  }

  // ================= APPROVE =================
  static Future<void> setujui(String id) async {
    await supabase
        .from('peminjaman')
        .update({'status': 'disetujui'})
        .eq('id', id);
  }

  // ================= TOLAK =================
  static Future<void> tolak(String id) async {
    await supabase
        .from('peminjaman')
        .update({'status': 'ditolak'})
        .eq('id', id);
  }

  // ================= DATA PRATINJAU (PENGEMBALIAN) =================
  static Future<List<Map<String, dynamic>>> getPengembalian() async {
    final response = await supabase
        .from('peminjaman')
        .select('''
          *,
          user:user_id(nama),
          alat:detail_peminjaman!inner(
            alat:alat_id(nama)
          )
        ''')
        .eq('status', 'dikembalikan');

    return List<Map<String, dynamic>>.from(response);
  }

  // ================= KONFIRMASI PENGEMBALIAN =================
  static Future<void> konfirmasiKembali(String id) async {
    await supabase
        .from('peminjaman')
        .update({'status': 'selesai'})
        .eq('id', id);
  }
}
