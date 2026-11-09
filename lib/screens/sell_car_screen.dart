import 'package:flutter/material.dart';

import '../models/brand.dart';
import '../models/car.dart';
import '../providers/app_state.dart';
import '../providers/theme_provider.dart';

// ============================================================
// LAYAR: SellCarScreen (tab Jual)
// Form pasang iklan jual mobil. Iklan yang dipasang masuk ke
// AppState.myListings (hanya di memori, hilang saat app ditutup)
// dan langsung muncul di layar Cari, Merek, dan Profil.
// ============================================================

class SellCarScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  final AppState appState;

  const SellCarScreen({
    super.key,
    required this.themeProvider,
    required this.appState,
  });

  @override
  State<SellCarScreen> createState() => _SellCarScreenState();
}

class _SellCarScreenState extends State<SellCarScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _engineController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _sellerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Brand? _selectedBrand;
  CarCondition _condition = CarCondition.bekas;
  String _transmission = 'Otomatis';
  String _fuel = 'Bensin';

  static const List<String> transmissionOptions = [
    'Otomatis',
    'Manual',
    'CVT',
  ];
  static const List<String> fuelOptions = ['Bensin', 'Hybrid', 'Diesel'];

  @override
  void dispose() {
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    _kmController.dispose();
    _engineController.dispose();
    _colorController.dispose();
    _locationController.dispose();
    _sellerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  String? _numberValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    if (int.tryParse(value.trim()) == null) {
      return '$fieldName harus berupa angka';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBrand == null) return; // Sudah divalidasi di dropdown

    final car = Car(
      id: 'iklan-${DateTime.now().millisecondsSinceEpoch}',
      brand: _selectedBrand!.name,
      model: _modelController.text.trim(),
      country: _selectedBrand!.country,
      year: int.parse(_yearController.text.trim()),
      price: int.parse(_priceController.text.trim()),
      condition: _condition,
      kilometer: int.parse(_kmController.text.trim()),
      transmission: _transmission,
      fuel: _fuel,
      engine: _engineController.text.trim(),
      color: _colorController.text.trim(),
      location: _locationController.text.trim(),
      seller: _sellerController.text.trim(),
      description: _descriptionController.text.trim(),
      // Iklan pengguna belum punya foto: tampil placeholder tema.
      imageUrl: '',
    );

    widget.appState.addListing(car);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Iklan berhasil dipasang! Lihat di tab Profil.'),
      ),
    );

    // Bersihkan form untuk iklan berikutnya.
    _formKey.currentState!.reset();
    _modelController.clear();
    _yearController.clear();
    _priceController.clear();
    _kmController.clear();
    _engineController.clear();
    _colorController.clear();
    _locationController.clear();
    _sellerController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedBrand = null;
      _condition = CarCondition.bekas;
      _transmission = 'Otomatis';
      _fuel = 'Bensin';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jual Mobilmu',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Isi data mobilmu. Iklan tersimpan di memori HP (prototipe) '
              'dan akan hilang saat aplikasi ditutup.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // ---------- Merek ----------
            DropdownButtonFormField<Brand>(
              value: _selectedBrand,
              decoration: const InputDecoration(labelText: 'Merek *'),
              hint: const Text('Pilih merek'),
              items: brands
                  .map(
                    (brand) => DropdownMenuItem(
                      value: brand,
                      child: Text('${brand.name} (${brand.country.label})'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedBrand = value);
              },
              validator: (value) =>
                  value == null ? 'Merek wajib dipilih' : null,
            ),
            const SizedBox(height: 12),

            // ---------- Model ----------
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model *',
                hintText: 'Contoh: Avanza 1.5 G CVT',
              ),
              validator: (value) => _requiredValidator(value, 'Model'),
            ),
            const SizedBox(height: 12),

            // ---------- Tahun + Harga ----------
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tahun *',
                      hintText: '2023',
                    ),
                    validator: (value) {
                      final error = _numberValidator(value, 'Tahun');
                      if (error != null) return error;
                      final year = int.parse(value!.trim());
                      if (year < 1990 || year > 2026) {
                        return 'Tahun 1990-2026';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Harga (Rp) *',
                      hintText: '250000000',
                    ),
                    validator: (value) {
                      final error = _numberValidator(value, 'Harga');
                      if (error != null) return error;
                      if (int.parse(value!.trim()) <= 0) {
                        return 'Harga harus lebih dari 0';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ---------- Kondisi ----------
            const Text(
              'Kondisi *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<CarCondition>(
                    title: const Text('Baru'),
                    value: CarCondition.baru,
                    groupValue: _condition,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() => _condition = value!);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<CarCondition>(
                    title: const Text('Bekas'),
                    value: CarCondition.bekas,
                    groupValue: _condition,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() => _condition = value!);
                    },
                  ),
                ),
              ],
            ),

            // ---------- Kilometer + Mesin ----------
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Kilometer *',
                      hintText: '0 untuk mobil baru',
                    ),
                    validator: (value) {
                      final error = _numberValidator(value, 'Kilometer');
                      if (error != null) return error;
                      if (int.parse(value!.trim()) < 0) {
                        return 'Kilometer tidak boleh negatif';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _engineController,
                    decoration: const InputDecoration(
                      labelText: 'Mesin *',
                      hintText: 'Contoh: 1.5L',
                    ),
                    validator: (value) => _requiredValidator(value, 'Mesin'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ---------- Transmisi + Bahan bakar ----------
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _transmission,
                    decoration: const InputDecoration(labelText: 'Transmisi'),
                    items: transmissionOptions
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _transmission = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fuel,
                    decoration:
                        const InputDecoration(labelText: 'Bahan Bakar'),
                    items: fuelOptions
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _fuel = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ---------- Warna + Lokasi ----------
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _colorController,
                    decoration: const InputDecoration(
                      labelText: 'Warna *',
                      hintText: 'Contoh: Putih',
                    ),
                    validator: (value) => _requiredValidator(value, 'Warna'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Lokasi *',
                      hintText: 'Contoh: Jakarta Selatan',
                    ),
                    validator: (value) =>
                        _requiredValidator(value, 'Lokasi'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ---------- Nama penjual ----------
            TextFormField(
              controller: _sellerController,
              decoration: const InputDecoration(
                labelText: 'Nama Penjual *',
                hintText: 'Nama kamu atau nama dealer',
              ),
              validator: (value) => _requiredValidator(value, 'Nama penjual'),
            ),
            const SizedBox(height: 12),

            // ---------- Deskripsi ----------
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi *',
                hintText: 'Ceritakan kondisi mobilmu...',
              ),
              validator: (value) => _requiredValidator(value, 'Deskripsi'),
            ),
            const SizedBox(height: 20),

            // ---------- Tombol pasang iklan ----------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.publish),
                label: const Text('Pasang Iklan'),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Foto belum bisa diunggah di prototipe ini — iklanmu akan '
              'tampil dengan gambar placeholder warna tema, sedangkan '
              'mobil katalog memakai foto asli.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
