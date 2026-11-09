import 'package:flutter/material.dart';

import '../models/car.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';
import '../screens/car_detail_screen.dart';
import '../utils/format.dart';

// ============================================================
// WIDGET: CarCard
// Kartu satu mobil, dipakai di Beranda, Cari, Favorit, Merek.
// Ketuk kartu -> buka CarDetailScreen (tema ikut berubah
// mengikuti negara mobil).
//
// FOTO: belum ada foto asli. Gambar diganti placeholder berupa
// container gradasi warna tema + ikon mobil + nama model.
// ============================================================

class CarCard extends StatelessWidget {
  final Car car;
  final AppState appState;
  final ThemeProvider themeProvider;

  const CarCard({
    super.key,
    required this.car,
    required this.appState,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder: kartu digambar ulang saat favorit /
    // bandingkan berubah, supaya ikon hati langsung berubah.
    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        final theme = Theme.of(context);
        final isFavorite = appState.isFavorite(car.id);
        final inCompare = appState.isInCompare(car.id);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarDetailScreen(
                    car: car,
                    themeProvider: themeProvider,
                    appState: appState,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- Gambar placeholder ----------
                Container(
                  height: 150,
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
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.directions_car,
                              size: 56,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              car.model,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Chip negara di pojok kiri atas
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${car.country.code} • ${car.country.label}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Chip kondisi di pojok kanan atas
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: car.condition == CarCondition.baru
                                ? Colors.green
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            car.condition.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------- Info mobil ----------
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${car.brand} ${car.model}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatRupiah(car.price),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Tahun • KM • Transmisi
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _infoChip('${car.year}', Icons.calendar_today),
                          _infoChip(formatKm(car.kilometer), Icons.speed),
                          _infoChip(car.transmission, Icons.settings),
                          _infoChip(car.location, Icons.location_on),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Tombol favorit & bandingkan
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              appState.toggleFavorite(car.id);
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            tooltip: isFavorite
                                ? 'Hapus dari favorit'
                                : 'Simpan ke favorit',
                          ),
                          IconButton(
                            onPressed: () {
                              final ok = appState.toggleCompare(car.id);
                              if (!ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Maksimal 3 mobil untuk dibandingkan.',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              Icons.compare_arrows,
                              color: inCompare
                                  ? theme.colorScheme.primary
                                  : Colors.grey,
                            ),
                            tooltip: inCompare
                                ? 'Hapus dari perbandingan'
                                : 'Tambah ke perbandingan',
                          ),
                          const Spacer(),
                          Text(
                            car.fuel,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Chip kecil untuk info singkat (tahun, KM, transmisi, lokasi)
  Widget _infoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
