// lib/routes/app_routes.dart
import 'package:flutter/widgets.dart';

// PEMINJAM
import '../screens/peminjam_beranda_page.dart';
import '../screens/peminjam_alat_page.dart';
import '../screens/peminjam_riwayat_page.dart';
import '../screens/peminjam_profil_page.dart';
import '../screens/peminjam_peminjaman_page.dart'; // pastikan file ini ada

// ADMIN
import '../screens/admin_dashboard.dart';
import '../screens/admin_page.dart';
import '../screens/admin_edit_page.dart';
import '../screens/transaksi.dart';
import '../screens/riwayat_page.dart';

// PETUGAS
import '../screens/petugas_dashboard.dart';
import '../screens/petugas_beranda_page.dart';
import '../screens/petugas_pratinjau_page.dart';
import '../screens/petugas_laporan_page.dart';

// AUTH
import '../auth/login_page.dart';

class AppRoutes {
  // PEMINJAM
  static const String beranda = '/peminjam-beranda';
  static const String alat = '/peminjam-alat';
  static const String peminjamanUser = '/peminjam-peminjaman'; // route peminjaman
  static const String riwayat = '/peminjam-riwayat';
  static const String profilDetail = '/peminjam-profil';

  // ADMIN
  static const String adminDashboard = '/admin-dashboard';
  static const String edit = '/admin-edit';
  static const String transaksi = '/admin-transaksi';
  static const String riwayatAdmin = '/admin-riwayat';

  // PETUGAS
  static const String petugasDashboard = '/petugas-dashboard';
  static const String petugasBeranda = '/petugas-beranda';
  static const String petugasPratinjau = '/petugas-pratinjau';
  static const String petugasLaporan = '/petugas-laporan';

  // AUTH
  static const String login = '/login';

  // ROUTE MAP (hanya halaman tanpa parameter)
  static Map<String, Widget Function(BuildContext)> get routes => {
        // PEMINJAM
        beranda: (_) => const PeminjamBerandaPage(),
        alat: (_) => const AlatPage(),
        peminjamanUser: (_) => const PeminjamanPage(), // route Peminjaman
        riwayat: (_) => const RiwayatPage(),
        profilDetail: (_) => const PeminjamProfilPage(),

        // ADMIN
        adminDashboard: (_) => const AdminDashboard(),
        edit: (_) => const AdminPage(),
        transaksi: (_) => const TransaksiPage(),
        riwayatAdmin: (_) => const RiwayatPage(),

        // PETUGAS
        petugasDashboard: (_) => const PetugasDashboard(),
        petugasBeranda: (_) => const PetugasBerandaPage(),
        petugasPratinjau: (_) => const PetugasPratinjauPage(),
        petugasLaporan: (_) => const PetugasLaporanPage(),

        // AUTH
        login: (_) => const LoginPage(),
      };
}
