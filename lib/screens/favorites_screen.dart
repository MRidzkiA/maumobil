import 'package:flutter/material.dart';

import '../data/cars.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';
import '../widgets/car_card.dart';

// ============================================================
// LAYAR: FavoritesScreen (tab Favorit)
// Menampilkan semua mobil yang disimpan pengguna.
// ============================================================

class FavoritesScreen extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AppState appState;

  const FavoritesScreen({
    super.key,
    required this.themeProvider,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, child) {
        final favoriteCars = [
          ...cars,
          ...appState.myListings,
        ].where((car) => appState.isFavorite(car.id)).toList();

        if (favoriteCars.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada mobil favorit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ketuk ikon hati di kartu mobil\nuntuk menyimpannya di sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteCars.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CarCard(
                car: favoriteCars[index],
                appState: appState,
                themeProvider: themeProvider,
              ),
            );
          },
        );
      },
    );
  }
}
