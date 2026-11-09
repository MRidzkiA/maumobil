import 'package:flutter/material.dart';

import '../models/car.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';
import '../utils/format.dart';
import 'credit_simulator_screen.dart';

// ============================================================
// LAYAR: CarDetailScreen (detail satu mobil)
// Dibuka dari CarCard. Saat halaman ini dibuka, tema aplikasi
// langsung berubah mengikuti negara mobil tersebut.
// Isi: galeri placeholder, harga, spesifikasi, deskripsi,
// info penjual, tombol favorit, bandingkan, dan simulasi kredit.
// ============================================================

class CarDetailScreen extends StatefulWidget {
  final Car car;
  final ThemeProvider themeProvider;
  final AppState appState;

  const CarDetailScreen({
    super.key,
    required this.car,
    required this.themeProvider,
    required this.appState,
  });

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Tema berubah mengikuti negara mobil yang dibuka.
    widget.themeProvider.applyCar(widget.car);
  }

  void _openCreditSimulator() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreditSimulatorScreen(initialPrice: widget.car.price),
      ),
    );
  }

  void _showComingSoon(String fitur) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$fitur segera hadir di fase berikutnya (prototipe).'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('${car.brand} ${car.model}')),
      body: AnimatedBuilder(
        animation: widget.appState,
        builder: (context, child) {
          final isFavorite = widget.appState.isFavorite(car.id);
          final inCompare = widget.appState.isInCompare(car.id);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- Galeri placeholder ----------
                Container(
                  height: 220,
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
                              size: 80,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${car.brand} ${car.model}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Foto asli belum tersedia (prototipe)',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${car.country.code} • ${car.country.label}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------- Harga + kondisi ----------
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatRupiah(car.price),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          Container(
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${car.year} • ${car.location}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ---------- Tombol aksi ----------
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                widget.appState.toggleFavorite(car.id);
                              },
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              label: Text(
                                isFavorite ? 'Favorit ✓' : 'Favorit',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                final ok =
                                    widget.appState.toggleCompare(car.id);
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
                              icon: const Icon(Icons.compare_arrows),
                              label: Text(
                                inCompare ? 'Bandingkan ✓' : 'Bandingkan',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _openCreditSimulator,
                          icon: const Icon(Icons.calculate),
                          label: const Text('Simulasi Kredit'),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ---------- Spesifikasi ----------
                      const Text(
                        'Spesifikasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              _specRow('Tahun', '${car.year}'),
                              _specRow('Kondisi', car.condition.label),
                              _specRow('Kilometer', formatKm(car.kilometer)),
                              _specRow('Transmisi', car.transmission),
                              _specRow('Bahan Bakar', car.fuel),
                              _specRow('Mesin', car.engine),
                              _specRow('Warna', car.color),
                              _specRow('Lokasi', car.location),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ---------- Deskripsi ----------
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        car.description,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 20),

                      // ---------- Penjual ----------
                      const Text(
                        'Penjual',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor:
                                    theme.colorScheme.primary,
                                child: Text(
                                  car.seller[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      car.seller,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'Penjual di MauMobil',
                                      style: TextStyle(
                                        fontSize: 12,
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
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showComingSoon('Fitur chat'),
                              icon: const Icon(Icons.chat),
                              label: const Text('Chat'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _showComingSoon('Fitur telepon'),
                              icon: const Icon(Icons.phone),
                              label: const Text('Telepon'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Catatan: harga di atas adalah perkiraan untuk prototipe, bukan harga resmi.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Satu baris spesifikasi: label kiri, nilai kanan
  Widget _specRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
