import 'package:flutter/material.dart';

import '../data/cars.dart';
import '../models/brand.dart';
import '../models/car.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';
import '../widgets/app_route.dart';
import '../widgets/car_card.dart';
import 'compare_screen.dart';

// ============================================================
// LAYAR: CarListScreen (tab Cari + hasil pencarian dari Beranda)
// Filter: kata kunci, negara (sekaligus ganti tema), merek,
// kondisi (baru/bekas), harga maks, dan urutan.
// ============================================================

class CarListScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  final AppState appState;
  final Country? initialCountry;
  final String? initialQuery;

  const CarListScreen({
    super.key,
    required this.themeProvider,
    required this.appState,
    this.initialCountry,
    this.initialQuery,
  });

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late final TextEditingController _searchController;
  late String _query;
  Country? _country;
  String _brand = 'Semua';
  CarCondition? _condition; // null = semua
  String _maxPriceLabel = 'Semua';
  String _sort = 'rekomendasi';

  // Pilihan harga maks (label -> nilai Rupiah, null = semua)
  static const Map<String, int?> maxPriceOptions = {
    'Semua': null,
    '≤ Rp 250 Jt': 250000000,
    '≤ Rp 500 Jt': 500000000,
    '≤ Rp 750 Jt': 750000000,
    '≤ Rp 1 M': 1000000000,
  };

  static const Map<String, String> sortOptions = {
    'rekomendasi': 'Rekomendasi',
    'termurah': 'Harga Termurah',
    'termahal': 'Harga Termahal',
    'tahun': 'Tahun Terbaru',
  };

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? '';
    _searchController = TextEditingController(text: _query);
    _country = widget.initialCountry;
    // Kalau dibuka dengan negara tertentu, tema langsung mengikuti.
    if (_country != null) {
      widget.themeProvider.selectCountry(_country);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Semua mobil: katalog + iklan yang dipasang pengguna sendiri
  List<Car> get _allCars => [...cars, ...widget.appState.myListings];

  // Terapkan semua filter + urutan
  List<Car> get _filteredCars {
    var result = _allCars.where((car) {
      if (_query.isNotEmpty) {
        final keyword = '${car.brand} ${car.model}'.toLowerCase();
        if (!keyword.contains(_query.toLowerCase())) return false;
      }
      if (_country != null && car.country != _country) return false;
      if (_brand != 'Semua' && car.brand != _brand) return false;
      if (_condition != null && car.condition != _condition) return false;
      final maxPrice = maxPriceOptions[_maxPriceLabel];
      if (maxPrice != null && car.price > maxPrice) return false;
      return true;
    }).toList();

    switch (_sort) {
      case 'termurah':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'termahal':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'tahun':
        result.sort((a, b) => b.year.compareTo(a.year));
        break;
      default:
        break; // 'rekomendasi' = urutan asli katalog
    }
    return result;
  }

  void _openCompare() {
    Navigator.push(
      context,
      fadeSlideRoute(
        CompareScreen(
          themeProvider: widget.themeProvider,
          appState: widget.appState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // AnimatedBuilder: daftar ikut berubah saat iklan baru dipasang
    // atau mobil ditambah/dihapus dari perbandingan.
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, child) {
        final filtered = _filteredCars;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ---------- Pencarian ----------
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari merek atau model mobil...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() => _query = value);
                    },
                  ),
                  const SizedBox(height: 12),

                  // ---------- Filter negara (sekaligus ganti tema) ----------
                  Row(
                    children: [
                      _filterChip(
                        label: 'Semua',
                        isSelected: _country == null,
                        onTap: () {
                          setState(() => _country = null);
                          widget.themeProvider.selectCountry(null);
                        },
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        label: '🇯🇵 Jepang',
                        isSelected: _country == Country.jepang,
                        onTap: () {
                          setState(() => _country = Country.jepang);
                          widget.themeProvider
                              .selectCountry(Country.jepang);
                        },
                      ),
                      const SizedBox(width: 8),
                      _filterChip(
                        label: '🇪🇺 Eropa',
                        isSelected: _country == Country.eropa,
                        onTap: () {
                          setState(() => _country = Country.eropa);
                          widget.themeProvider.selectCountry(Country.eropa);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ---------- Filter merek + kondisi ----------
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _brand,
                          decoration: const InputDecoration(
                            labelText: 'Merek',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: [
                            'Semua',
                            ...brands.map((b) => b.name),
                          ]
                              .map(
                                (name) => DropdownMenuItem(
                                  value: name,
                                  child: Text(name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _brand = value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<CarCondition?>(
                          value: _condition,
                          decoration: const InputDecoration(
                            labelText: 'Kondisi',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem<CarCondition?>(
                              value: null,
                              child: Text('Semua'),
                            ),
                            DropdownMenuItem<CarCondition?>(
                              value: CarCondition.baru,
                              child: Text('Baru'),
                            ),
                            DropdownMenuItem<CarCondition?>(
                              value: CarCondition.bekas,
                              child: Text('Bekas'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _condition = value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ---------- Filter harga maks + urutan ----------
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _maxPriceLabel,
                          decoration: const InputDecoration(
                            labelText: 'Harga Maks',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: maxPriceOptions.keys
                              .map(
                                (label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(label),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _maxPriceLabel = value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _sort,
                          decoration: const InputDecoration(
                            labelText: 'Urutkan',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          items: sortOptions.entries
                              .map(
                                (entry) => DropdownMenuItem(
                                  value: entry.key,
                                  child: Text(entry.value),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _sort = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  // ---------- Tombol bandingkan ----------
                  if (widget.appState.compareIds.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _openCompare,
                        icon: const Icon(Icons.compare_arrows),
                        label: Text(
                          'Bandingkan (${widget.appState.compareCount} mobil)',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ---------- Hasil ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filtered.length} mobil ditemukan',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Tidak ada mobil yang cocok.\nCoba ubah kata kunci atau filter.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CarCard(
                            car: filtered[index],
                            appState: widget.appState,
                            themeProvider: widget.themeProvider,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _filterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
