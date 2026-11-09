import 'package:flutter/material.dart';

import '../models/car.dart';

// ============================================================
// WIDGET: CarImage
// Foto asli mobil dari URL publik (Image.network).
// Kalau URL kosong / gambar gagal dimuat (misal offline),
// otomatis menampilkan placeholder gradasi warna tema,
// jadi kartu tidak pernah kosong dan aplikasi tidak crash.
// ============================================================

class CarImage extends StatelessWidget {
  final Car car;
  final double height;

  const CarImage({
    super.key,
    required this.car,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (car.imageUrl.isEmpty) {
      return _placeholder(context);
    }
    return Image.network(
      car.imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      // Saat gambar sedang diunduh: tampilkan spinner halus.
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: height,
          width: double.infinity,
          color: Colors.grey[100],
          child: const Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
      // Kalau gambar gagal dimuat: tampilkan placeholder.
      errorBuilder: (context, error, stackTrace) => _placeholder(context),
    );
  }

  // Placeholder gradasi warna tema + ikon mobil + nama model.
  Widget _placeholder(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car,
              size: 56,
              color: Colors.white,
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                car.model,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
