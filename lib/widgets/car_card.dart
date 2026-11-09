import 'package:flutter/material.dart';

import '../models/car.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';
import '../screens/car_detail_screen.dart';
import '../utils/format.dart';
import 'app_route.dart';
import 'car_image.dart';
import 'favorite_button.dart';

// ============================================================
// WIDGET: CarCard
// Kartu satu mobil, dipakai di Beranda, Cari, Favorit, Merek.
// Ketuk kartu -> buka CarDetailScreen (tema ikut berubah
// mengikuti negara mobil).
//
// FOTO: foto asli dari car.imageUrl (Image.network, lihat
// CarImage). Kalau gagal dimuat, tampil placeholder gradasi.
// Gaya minimalis: sudut membulat lembut, bayangan halus,
// spacing konsisten.
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
    // bandingkan berubah, supaya ikon langsung berubah.
    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        final theme = Theme.of(context);
        final inCompare = appState.isInCompare(car.id);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  fadeSlideRoute(
                    CarDetailScreen(
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
                  // ---------- Foto asli mobil ----------
                  Stack(
                    children: [
                      CarImage(car: car, height: 160),
                      // Chip negara di pojok kiri atas
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
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
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
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

                  // ---------- Info mobil ----------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
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
                        const SizedBox(height: 10),
                        // Tahun • KM • Transmisi • Lokasi
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
                            FavoriteButton(
                              appState: appState,
                              carId: car.id,
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
          ),
        );
      },
    );
  }

  // Chip kecil untuk info singkat (tahun, KM, transmisi, lokasi)
  Widget _infoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[100],
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
