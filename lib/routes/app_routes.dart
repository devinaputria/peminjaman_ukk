import 'package:flutter/material.dart';
import 'package:peminjaman/screens/peminjam_alat_page.dart';
import 'package:peminjaman/screens/peminjam_dashboard.dart';
import 'package:peminjaman/screens/peminjam_detail_profil_page.dart';
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

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    admin: (_) => const AdminDashboard(),
    petugas: (_) => const PetugasDashboard(),
    peminjam: (_) => const PeminjamDashboard(),
    alat: (_) => const AlatPage(),
    profilDetail: (_) => const PeminjamProfilDetailPage(),
  };
}
