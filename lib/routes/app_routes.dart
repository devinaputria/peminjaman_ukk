import 'package:flutter/material.dart';
import 'package:peminjaman/screens/alat_crud_page.dart';
import 'package:peminjaman/screens/peminjam_alat_page.dart';
import 'package:peminjaman/screens/peminjam_beranda_page.dart';
import 'package:peminjaman/screens/peminjam_dashboard.dart';
import 'package:peminjaman/screens/peminjam_riwayat_page.dart';
import 'package:peminjaman/screens/peminjam_detail_profil_page.dart';
import 'package:peminjaman/screens/petugas_beranda_page.dart';
import 'package:peminjaman/screens/petugas_dashboard.dart';
import '../auth/login_page.dart';
import '../screens/admin_dashboard.dart';

class AppRoutes {
  static const login = '/';
  static const admin = '/admin';
  static const petugas = '/petugas';
  static const peminjam = '/peminjam';
  static const alat = '/alat';
  static const profilDetail = '/profil-detail';
  static const riwayat = '/riwayat';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    admin: (_) => const AdminDashboard(),
    petugas: (_) => const PetugasBerandaPage(),
    peminjam: (_) => const PeminjamBerandaPage(),
    alat: (_) => const AlatPage(), // tetap pakai UI lama peminjam
    profilDetail: (_) => const PeminjamProfilDetailPage(),
    riwayat: (_) => const PeminjamRiwayatPage(),
  };
}
