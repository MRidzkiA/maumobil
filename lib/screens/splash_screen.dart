import 'package:flutter/material.dart';

// ============================================================
// LAYAR: SplashScreen (layar pembuka)
// Tampil sebentar saat aplikasi dibuka: logo utama MauMobil
// (maumobil-logo.png) di tengah latar putih, dengan tagline
// dan indikator loading halus.
// ============================================================

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo utama MauMobil (logo lengkap + wordmark).
            Image.asset(
              'assets/logo/maumobil-logo.png',
              width: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              'Cari mobil impianmu',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
