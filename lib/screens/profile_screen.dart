import 'package:flutter/material.dart';

import '../data/cars.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';
import '../utils/format.dart';
import '../widgets/app_route.dart';
import 'car_detail_screen.dart';

// ============================================================
// LAYAR: ProfileScreen (tab Profil)
// Isi: info pengguna, statistik (jumlah iklan & favorit),
// daftar "Iklan Saya" (bisa dihapus), dan daftar favorit.
// ============================================================

class ProfileScreen extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AppState appState;

  const ProfileScreen({
    super.key,
    required this.themeProvider,
    required this.appState,
  });

  void _openDetail(BuildContext context, String carId) {
    final allCars = [...cars, ...appState.myListings];
    final car = allCars.firstWhere((c) => c.id == carId);
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        final myListings = appState.myListings;
        final favoriteCars = [
          ...cars,
          ...myListings,
        ].where((car) => appState.isFavorite(car.id)).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Info pengguna ----------
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: theme.colorScheme.primary,
                        child: const Text(
                          'R',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ridzki',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Pengguna MauMobil • Jakarta',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ---------- Statistik ----------
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      context,
                      label: 'Iklan Saya',
                      value: '${myListings.length}',
                      icon: Icons.store,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      context,
                      label: 'Favorit',
                      value: '${favoriteCars.length}',
                      icon: Icons.favorite,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ---------- Iklan Saya ----------
              const Text(
                'Iklan Saya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (myListings.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Belum ada iklan. Pasang iklan lewat tab Jual.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...myListings.map(
                  (car) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        child: const Icon(
                          Icons.directions_car,
                          color: Colors.white,
                        ),
                      ),
                      title: Text('${car.brand} ${car.model}'),
                      subtitle: Text(
                        '${formatRupiah(car.price)} • ${car.year}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Hapus iklan',
                        onPressed: () {
                          appState.removeListing(car.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Iklan dihapus.'),
                            ),
                          );
                        },
                      ),
                      onTap: () => _openDetail(context, car.id),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // ---------- Favorit Saya ----------
              const Text(
                'Favorit Saya',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (favoriteCars.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Belum ada mobil favorit.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...favoriteCars.map(
                  (car) => Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      title: Text('${car.brand} ${car.model}'),
                      subtitle: Text(
                        '${formatRupiah(car.price)} • ${car.year}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () => _openDetail(context, car.id),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // ---------- Tentang ----------
              const Text(
                'Tentang MauMobil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'MauMobil v1.1.0 — aplikasi jual beli mobil baru & bekas. '
                'Tema aplikasi berubah mengikuti negara asal mobil: Jepang atau Eropa.\n\n'
                'Foto mobil dimuat dari internet; kalau offline, tampil placeholder warna tema. '
                'Chat penjual aktif sebagai simulasi lokal di prototipe ini.\n\n'
                'Harga yang tampil adalah perkiraan untuk prototipe, bukan harga resmi.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
