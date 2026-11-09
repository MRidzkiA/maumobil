import 'package:flutter/material.dart';

import '../data/cars.dart';
import '../models/car.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';
import '../utils/format.dart';
import '../widgets/app_route.dart';
import '../widgets/car_image.dart';
import 'car_detail_screen.dart';

// ============================================================
// LAYAR: CompareScreen (bandingkan mobil)
// Membandingkan sampai 3 mobil dalam satu tabel:
// foto, harga, tahun, kondisi, kilometer, transmisi,
// bahan bakar, mesin, warna, lokasi, dan negara.
// Dibuka dari tombol "Bandingkan" di layar Cari / Detail.
// ============================================================

class CompareScreen extends StatelessWidget {
  final ThemeProvider themeProvider;
  final AppState appState;

  const CompareScreen({
    super.key,
    required this.themeProvider,
    required this.appState,
  });

  // Cari mobil berdasarkan id. Mengembalikan null kalau id
  // tidak ditemukan (misal iklan sudah dihapus) — mobil seperti
  // itu dilewati, bukan diganti mobil lain.
  Car? _findCar(List<Car> allCars, String id) {
    for (final car in allCars) {
      if (car.id == id) return car;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bandingkan Mobil')),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, child) {
          // Mobil yang dipilih, diurutkan sesuai urutan pilihan.
          // Id yang tidak ditemukan dilewati (tidak diganti mobil lain).
          final allCars = [...cars, ...appState.myListings];
          final compareCars = appState.compareIds
              .map((id) => _findCar(allCars, id))
              .whereType<Car>()
              .toList();

          if (compareCars.length < 2) {
            return _buildPickList(context, allCars);
          }
          return _buildTable(context, compareCars);
        },
      ),
    );
  }

  // ---------- Tampilan saat mobil yang dipilih kurang dari 2 ----------
  Widget _buildPickList(BuildContext context, List<Car> allCars) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Pilih minimal 2 mobil untuk dibandingkan (maksimal 3). '
            'Ketuk ikon bandingkan di kartu mobil untuk menambah.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: allCars.length,
            itemBuilder: (context, index) {
              final car = allCars[index];
              final inCompare = appState.isInCompare(car.id);
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
                  icon: Icon(
                    Icons.compare_arrows,
                    color: inCompare
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------- Tabel perbandingan ----------
  Widget _buildTable(BuildContext context, List<Car> compareCars) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chip mobil yang dibandingkan (bisa dihapus)
          Wrap(
            spacing: 8,
            children: compareCars.map((car) {
              return Chip(
                label: Text('${car.brand} ${car.model}'),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => appState.removeFromCompare(car.id),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Tombol bersihkan semua
          TextButton.icon(
            onPressed: () {
              appState.clearCompare();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perbandingan dibersihkan.'),
                ),
              );
            },
            icon: const Icon(Icons.clear_all, size: 18),
            label: const Text('Bersihkan Semua'),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 24,
                  columns: [
                    const DataColumn(
                      label: Text(
                        'Spesifikasi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...compareCars.map(
                      (car) => DataColumn(
                        label: Text(
                          '${car.brand}\n${car.model}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    // Baris foto: ketuk foto untuk buka detail mobil.
                    DataRow(
                      cells: [
                        const DataCell(
                          Text(
                            'Foto',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...compareCars.map(
                          (car) => DataCell(
                            InkWell(
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 110,
                                  height: 70,
                                  child: CarImage(car: car, height: 70),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _row(
                      'Harga',
                      compareCars.map((c) => formatRupiah(c.price)).toList(),
                    ),
                    _row(
                      'Tahun',
                      compareCars.map((c) => '${c.year}').toList(),
                    ),
                    _row(
                      'Kondisi',
                      compareCars.map((c) => c.condition.label).toList(),
                    ),
                    _row(
                      'Kilometer',
                      compareCars.map((c) => formatKm(c.kilometer)).toList(),
                    ),
                    _row(
                      'Transmisi',
                      compareCars.map((c) => c.transmission).toList(),
                    ),
                    _row(
                      'Bahan Bakar',
                      compareCars.map((c) => c.fuel).toList(),
                    ),
                    _row(
                      'Mesin',
                      compareCars.map((c) => c.engine).toList(),
                    ),
                    _row(
                      'Warna',
                      compareCars.map((c) => c.color).toList(),
                    ),
                    _row(
                      'Lokasi',
                      compareCars.map((c) => c.location).toList(),
                    ),
                    _row(
                      'Negara',
                      compareCars.map((c) => c.country.label).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tips: ketuk chip mobil di atas untuk menghapusnya dari '
            'perbandingan, atau ketuk foto untuk melihat detail mobil.',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Harga termurah: ${formatRupiah(compareCars.map((c) => c.price).reduce((a, b) => a < b ? a : b))}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Satu baris tabel: label + satu nilai per mobil
  DataRow _row(String label, List<String> values) {
    return DataRow(
      cells: [
        DataCell(
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...values.map((value) => DataCell(Text(value))),
      ],
    );
  }
}
