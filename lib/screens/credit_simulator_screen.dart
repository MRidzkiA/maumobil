import 'dart:math';

import 'package:flutter/material.dart';

import '../utils/format.dart';

// ============================================================
// LAYAR: CreditSimulatorScreen (simulasi kredit mobil)
// Input: harga mobil, uang muka (DP), tenor (bulan), bunga
// (% per tahun). Cicilan dihitung dengan rumus anuitas:
//   cicilan = P * r * (1+r)^n / ((1+r)^n - 1)
//   P = harga - DP, r = bunga tahunan / 12 / 100, n = tenor
// Hasilnya hanya perkiraan — bunga asli tergantung bank/leasing.
// ============================================================

class CreditSimulatorScreen extends StatefulWidget {
  final int? initialPrice; // Harga mobil dari halaman detail (boleh kosong)

  const CreditSimulatorScreen({super.key, this.initialPrice});

  @override
  State<CreditSimulatorScreen> createState() => _CreditSimulatorScreenState();
}

class _CreditSimulatorScreenState extends State<CreditSimulatorScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dpController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  int _tenor = 36; // bulan
  bool _calculated = false;
  String? _error;
  double _cicilan = 0;
  double _pokok = 0;
  double _totalBayar = 0;
  double _totalBunga = 0;

  static const List<int> tenorOptions = [12, 24, 36, 48, 60];

  @override
  void initState() {
    super.initState();
    _priceController.text =
        widget.initialPrice?.toString() ?? '300000000';
    _dpController.text = '60000000';
    _rateController.text = '8';
  }

  @override
  void dispose() {
    _priceController.dispose();
    _dpController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  // Bersihkan angka dari titik/spasi pemisah ribuan yang mungkin
  // diketik pengguna (contoh: "300.000.000" -> 300000000).
  int? _parseRupiah(String text) {
    final cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned);
  }

  // Bunga boleh memakai koma desimal ala Indonesia ("8,5").
  double? _parseRate(String text) {
    final cleaned = text.trim().replaceAll(',', '.');
    return double.tryParse(cleaned);
  }

  void _hitung() {
    final price = _parseRupiah(_priceController.text.trim());
    final dp = _parseRupiah(_dpController.text.trim());
    final rate = _parseRate(_rateController.text.trim());

    setState(() {
      _error = null;
      _calculated = false;
    });

    if (price == null || price <= 0) {
      setState(() => _error = 'Harga mobil harus diisi angka yang benar.');
      return;
    }
    if (dp == null || dp < 0) {
      setState(() => _error = 'Uang muka (DP) harus diisi angka yang benar.');
      return;
    }
    if (dp >= price) {
      setState(() => _error = 'Uang muka harus lebih kecil dari harga mobil.');
      return;
    }
    if (rate == null || rate < 0) {
      setState(() => _error = 'Bunga harus diisi angka yang benar.');
      return;
    }

    final pokok = (price - dp).toDouble();
    final r = rate / 100 / 12; // Bunga per bulan
    final n = _tenor;
    double cicilan;
    if (r == 0) {
      cicilan = pokok / n;
    } else {
      final factor = pow(1 + r, n).toDouble();
      cicilan = pokok * r * factor / (factor - 1);
    }

    setState(() {
      _pokok = pokok;
      _cicilan = cicilan;
      _totalBayar = cicilan * n;
      _totalBunga = _totalBayar - pokok;
      _calculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Simulasi Kredit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hitung perkiraan cicilan bulananmu.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga Mobil (Rp)',
                hintText: 'Contoh: 300000000',
                prefixIcon: Icon(Icons.directions_car),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Uang Muka / DP (Rp)',
                hintText: 'Contoh: 60000000',
                prefixIcon: Icon(Icons.account_balance_wallet),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _tenor,
                    decoration: const InputDecoration(
                      labelText: 'Tenor',
                    ),
                    items: tenorOptions
                        .map(
                          (bulan) => DropdownMenuItem(
                            value: bulan,
                            child: Text('$bulan bulan'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _tenor = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _rateController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Bunga (% / tahun)',
                      hintText: 'Contoh: 8',
                      prefixIcon: Icon(Icons.percent),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            if (_error != null) const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _hitung,
                icon: const Icon(Icons.calculate),
                label: const Text('Hitung Cicilan'),
              ),
            ),
            const SizedBox(height: 20),
            if (_calculated)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hasil Simulasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Cicilan per bulan'),
                      Text(
                        '${formatRupiah(_cicilan.round())} / bulan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const Divider(height: 24),
                      _resultRow(
                        'Jumlah pinjaman',
                        formatRupiah(_pokok.round()),
                      ),
                      _resultRow('Tenor', '$_tenor bulan'),
                      _resultRow(
                        'Total bunga',
                        formatRupiah(_totalBunga.round()),
                      ),
                      _resultRow(
                        'Total yang dibayar',
                        formatRupiah(_totalBayar.round()),
                      ),
                    ],
                  ),
                ),
              ),
            if (_calculated) const SizedBox(height: 12),
            const Text(
              'Simulasi ini hanya perkiraan untuk prototipe. Cicilan asli '
              'tergantung bunga, biaya admin, dan kebijakan bank/leasing.',
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

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
