import 'package:flutter/material.dart';
import 'package:peminjaman/routes/app_routes.dart';
import 'package:peminjaman/screens/admin_dashboard.dart';
import 'package:peminjaman/screens/petugas_dashboard.dart';
import 'theme/app_colors.dart';
import 'auth/login_page.dart';
import 'screens/peminjam_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navbar,
          iconTheme: IconThemeData(color: AppColors.icon),
          titleTextStyle: TextStyle(
            color: AppColors.icon,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
