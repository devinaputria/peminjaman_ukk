import 'package:flutter/material.dart';
import '../auth/login_page.dart';
import '../screens/admin_dashboard.dart';
import 'package:peminjaman/screens/peminjam_dashboard.dart' as peminjam;
import 'package:peminjaman/screens/petugas_dashboard.dart' as petugas;
import 'package:peminjaman/screens/alat_crud_page.dart';
import 'package:peminjaman/screens/peminjam_alat_page.dart';
import 'package:peminjaman/screens/peminjam_beranda_page.dart';
import 'package:peminjaman/screens/peminjam_riwayat_page.dart';
import 'package:peminjaman/screens/peminjam_detail_profil_page.dart';
import 'package:peminjaman/screens/peminjam_peminjaman_page.dart';

class AppRoutes {
  static const login = '/';
  static const admin = '/admin';
  static const petugasRoute = '/petugas';
  static const peminjamRoute = '/peminjam';

  static const alat = '/alat';
  static const profilDetail = '/profil-detail';
  static const riwayat = '/riwayat';
  static const peminjaman = '/peminjaman';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    admin: (_) => const AdminDashboard(),
    petugasRoute: (_) => const petugas.PetugasDashboard(),
    peminjamRoute: (_) => const peminjam.PeminjamDashboardPage(), // <- fix

    // Halaman peminjam
   alat: (_) => const AlatPage(),                      // halaman alat
    profilDetail: (_) => const PeminjamProfilDetailPage(),
    riwayat: (_) => const PeminjamRiwayatPage(),
    peminjaman: (_) => const PeminjamanPage(selectedAlat: []), // halaman peminjaman
  };
}
