import 'package:flutter/material.dart';

import '../data/cars.dart';
import '../models/brand.dart';
import '../models/car.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';
import '../widgets/car_card.dart';

// ============================================================
// LAYAR: BrandScreen (halaman negara / merek)
// Dibuka dari Beranda saat pengguna mengetuk sebuah merek.
// Saat halaman ini dibuka, tema aplikasi langsung berubah
// mengikuti negara merek tersebut.
// ============================================================

class BrandScreen extends StatefulWidget {
  final Brand brand;
  final ThemeProvider themeProvider;
  final AppState appState;

  const BrandScreen({
    super.key,
    required this.brand,
    required this.themeProvider,
    required this.appState,
  });

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  @override
  void initState() {
    super.initState();
    // Tema berubah mengikuti negara merek ini.
    widget.themeProvider.selectCountry(widget.brand.country);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.brand.name)),
      body: AnimatedBuilder(
        animation: widget.appState,
        builder: (context, child) {
          // Hitung ulang di sini supaya iklan baru ikut muncul.
          final currentCars = [
            ...cars,
            ...widget.appState.myListings,
          ].where((car) => car.brand == widget.brand.name).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- Header merek ----------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: Text(
                          widget.brand.name[0],
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.brand.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '"${widget.brand.tagline}"',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Negara: ${widget.brand.country.label} • '
                        'Didirikan ${widget.brand.founded}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ---------- Daftar mobil merek ini ----------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${currentCars.length} mobil ${widget.brand.name}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: currentCars
                        .map(
                          (car) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CarCard(
                              car: car,
                              appState: widget.appState,
                              themeProvider: widget.themeProvider,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
