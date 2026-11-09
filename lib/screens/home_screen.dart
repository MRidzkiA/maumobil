import 'package:flutter/material.dart';

import '../data/cars.dart';
import '../models/brand.dart';
import '../models/car.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';
import '../widgets/car_card.dart';
import '../widgets/country_picker.dart';
import 'brand_screen.dart';
import 'car_list_screen.dart';

// ============================================================
// LAYAR: HomeScreen (tab Beranda)
// Isi: pencarian, pemilih negara (tema dinamis), banner tema,
// merek populer, dan mobil rekomendasi.
// ============================================================

class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  final AppState appState;

  const HomeScreen({
    super.key,
    required this.themeProvider,
    required this.appState,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Mobil rekomendasi: campuran Jepang + Eropa
  static const List<String> _featuredIds = ['avanza', 'crv', 'bmw320i', 'a4'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCarList({Country? country, String? query}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarListScreen(
          themeProvider: widget.themeProvider,
          appState: widget.appState,
          initialCountry: country,
          initialQuery: query,
        ),
      ),
    );
  }

  void _openBrand(Brand brand) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrandScreen(
          brand: brand,
          themeProvider: widget.themeProvider,
          appState: widget.appState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final featuredCars =
        cars.where((car) => _featuredIds.contains(car.id)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Sapaan ----------
          const Text(
            'Mau mobil apa hari ini?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Jual beli mobil baru & bekas, tema mengikuti negara mobilnya.',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),

          // ---------- Pencarian ----------
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari mobil, contoh: Avanza, CR-V, BMW...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _searchController.clear(),
              ),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                _openCarList(query: value.trim());
              }
            },
          ),
          const SizedBox(height: 20),

          // ---------- Pemilih negara (tema dinamis) ----------
          CountryPicker(themeProvider: widget.themeProvider),
          const SizedBox(height: 16),

          // ---------- Banner tema aktif ----------
          AnimatedBuilder(
            animation: widget.themeProvider,
            builder: (context, child) {
              final theme = Theme.of(context);
              final countryTheme = widget.themeProvider.currentCountryTheme;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      countryTheme.primary,
                      countryTheme.accent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tema ${countryTheme.name} aktif',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      countryTheme.tagline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        _openCarList(country: widget.themeProvider.country);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      child: Text(
                        widget.themeProvider.country == null
                            ? 'Lihat Semua Mobil'
                            : 'Lihat Mobil ${countryTheme.name}',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // ---------- Merek populer ----------
          const Text(
            'Merek Populer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 92,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => _openBrand(brand),
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 72,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Text(
                              brand.name[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            brand.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // ---------- Mobil rekomendasi ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rekomendasi Untukmu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => _openCarList(),
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...featuredCars.map(
            (car) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CarCard(
                car: car,
                appState: widget.appState,
                themeProvider: widget.themeProvider,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
