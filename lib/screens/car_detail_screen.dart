import 'package:flutter/material.dart';

import '../models/car.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';
import '../utils/format.dart';
import '../widgets/app_route.dart';
import '../widgets/car_image.dart';
import '../widgets/favorite_button.dart';
import 'chat_screen.dart';
import 'credit_simulator_screen.dart';

// ============================================================
// LAYAR: CarDetailScreen (detail satu mobil)
// Dibuka dari CarCard. Saat halaman ini dibuka, tema aplikasi
// langsung berubah mengikuti negara mobil tersebut.
// Isi: foto asli, harga, spesifikasi, deskripsi,
// info penjual, tombol favorit, bandingkan, simulasi kredit,
// chat penjual, dan telepon.
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
      fadeSlideRoute(
        CreditSimulatorScreen(initialPrice: widget.car.price),
      ),
    );
  }

  void _openChat() {
    Navigator.push(
      context,
      fadeSlideRoute(
        ChatScreen(car: widget.car, appState: widget.appState),
      ),
    );
  }

  // Telepon: nomor penjual belum ada di prototipe, jadi tampilkan
  // dialog dengan pilihan untuk lanjut ke chat.
  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hubungi ${widget.car.seller}'),
        content: const Text(
          'Nomor telepon penjual belum tersedia di prototipe ini. '
          'Silakan hubungi penjual lewat chat di dalam aplikasi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openChat();
            },
            child: const Text('Buka Chat'),
          ),
        ],
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
                // ---------- Foto asli mobil ----------
                Stack(
                  children: [
                    CarImage(car: car, height: 240),
                    Positioned(
                      top: 12,
                      left: 12,
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FavoriteButton(
                                    appState: widget.appState,
                                    carId: car.id,
                                    color: Colors.white70,
                                    activeColor: Colors.white,
                                  ),
                                  Text(
                                    isFavorite ? 'Favorit ✓' : 'Favorit',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
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
                              onPressed: _openChat,
                              icon: const Icon(Icons.chat),
                              label: const Text('Chat'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _showCallDialog,
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
