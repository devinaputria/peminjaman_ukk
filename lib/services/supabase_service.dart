import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // ================== CLIENT ==================
  static SupabaseClient get client => Supabase.instance.client;

  // ================== AUTH ==================

  /// LOGIN
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// LOGOUT
  static Future<void> logout() async {
    await client.auth.signOut();
  }

  /// CURRENT USER
  static User? get currentUser => client.auth.currentUser;

  /// SESSION
  static Session? get session => client.auth.currentSession;

  // ================== USER (ADMIN) ==================

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await client.from('users').select();
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addUser(Map<String, dynamic> data) async {
    await client.from('users').insert(data);
  }

  static Future<void> updateUser(int id, Map<String, dynamic> data) async {
    await client.from('users').update(data).eq('id', id);
  }

  static Future<void> deleteUser(int id) async {
    await client.from('users').delete().eq('id', id);
  }

  // ================== KATEGORI ==================

  static Future<List<Map<String, dynamic>>> getKategori() async {
    final response = await client.from('kategori').select();
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addKategori(Map<String, dynamic> data) async {
    await client.from('kategori').insert(data);
  }

  static Future<void> updateKategori(int id, Map<String, dynamic> data) async {
    await client.from('kategori').update(data).eq('id', id);
  }

  static Future<void> deleteKategori(int id) async {
    await client.from('kategori').delete().eq('id', id);
  }

  // ================== ALAT ==================

  static Future<List<Map<String, dynamic>>> getAlat() async {
    final response = await client
        .from('alat')
        .select('id, nama, kategori(id, nama)');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addAlat(Map<String, dynamic> data) async {
    await client.from('alat').insert(data);
  }

  static Future<void> updateAlat(int id, Map<String, dynamic> data) async {
    await client.from('alat').update(data).eq('id', id);
  }

  static Future<void> deleteAlat(int id) async {
    await client.from('alat').delete().eq('id', id);
  }

  // ================== PEMINJAMAN ==================

  static Future<List<Map<String, dynamic>>> getPeminjaman() async {
    final response = await client
        .from('peminjaman')
        .select('*, users(nama), alat(nama)');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addPeminjaman(Map<String, dynamic> data) async {
    await client.from('peminjaman').insert(data);
  }

  static Future<void> updatePeminjaman(
      int id, Map<String, dynamic> data) async {
    await client.from('peminjaman').update(data).eq('id', id);
  }

  static Future<void> deletePeminjaman(int id) async {
    await client.from('peminjaman').delete().eq('id', id);
  }

  // ================== PENGEMBALIAN ==================

  static Future<List<Map<String, dynamic>>> getPengembalian() async {
    final response = await client
        .from('pengembalian')
        .select('*, peminjaman(id), users(nama)');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> addPengembalian(Map<String, dynamic> data) async {
    await client.from('pengembalian').insert(data);
  }
}
