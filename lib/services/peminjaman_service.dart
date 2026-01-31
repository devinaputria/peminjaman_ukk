import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/log_helper.dart';

final supabase = Supabase.instance.client;

class PeminjamanService {
  // ================= INSERT =================
  static Future<void> insertPeminjaman(Map<String, dynamic> data) async {
    try {
      await supabase.from('peminjaman').insert(data);
      await tambahLog('INSERT data pada tabel peminjaman');
    } catch (e) {
      print('Gagal insert peminjaman: $e');
      rethrow;
    }
  }

  // ================= UPDATE =================
  static Future<void> updatePeminjaman(String id, Map<String, dynamic> data) async {
    try {
      await supabase.from('peminjaman').update(data).eq('id', id);
      await tambahLog('UPDATE data pada tabel peminjaman');
    } catch (e) {
      print('Gagal update peminjaman: $e');
      rethrow;
    }
  }

  // ================= APPROVE =================
  static Future<void> approvePeminjaman(String id) async {
    try {
      await supabase.from('peminjaman').update({'status': 'Approved'}).eq('id', id);
      await tambahLog('Approve peminjaman');
    } catch (e) {
      print('Gagal approve peminjaman: $e');
      rethrow;
    }
  }

  // ================= DELETE =================
  static Future<void> deletePeminjaman(String id) async {
    try {
      await supabase.from('peminjaman').delete().eq('id', id);
      await tambahLog('DELETE data pada tabel peminjaman');
    } catch (e) {
      print('Gagal delete peminjaman: $e');
      rethrow;
    }
  }
}
