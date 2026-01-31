import 'package:flutter/widgets.dart';
import 'package:peminjaman/screens/admin_page.dart';
import 'package:peminjaman/screens/detail_peminjaman_page.dart';

import '../screens/peminjam_beranda_page.dart';
import '../screens/peminjam_alat_page.dart';
import '../screens/peminjam_peminjaman_page.dart';
import '../screens/peminjam_riwayat_page.dart';
import '../screens/peminjam_profil_page.dart';
import '../screens/admin_dashboard.dart';
import '../screens/admin_edit_page.dart';
import '../screens/transaksi.dart';
import '../screens/riwayat_page.dart';
import '../auth/login_page.dart';

class AppRoutes {
  // Halaman Peminjam
  static const String beranda = '/peminjam-beranda';
  static const String alat = '/peminjam-alat';
  static const String peminjaman = '/peminjam-peminjaman';
  static const String riwayat = '/peminjam-riwayat';
  static const String profilDetail = '/peminjam-profil';

  // Halaman Admin
  static const String adminDashboard = '/admin-dashboard';
  static const String edit = '/admin-edit';
  static const String transaksi = '/admin-transaksi';
  static const String riwayatAdmin = '/admin-riwayat';

  // Login
  static const String login = '/login';

  // Map routes untuk MaterialApp
  static Map<String, Widget Function(BuildContext)> get routes => {
        beranda: (_) => const PeminjamBerandaPage(),
        alat: (_) => const AlatPage(),
        peminjaman: (_) => const DetailPeminjamanPage(),
        riwayat: (_) => const RiwayatPage(),
        profilDetail: (_) => const PeminjamProfilPage(),
        adminDashboard: (_) => const AdminDashboard(),
        edit: (_) => const AdminPage(),
        transaksi: (_) => const TransaksiPage(),
        riwayatAdmin: (_) => const RiwayatPage(),
        login: (_) => const LoginPage(),
      };
}
