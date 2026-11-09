import 'package:flutter/material.dart';

import '../models/car.dart';
import '../providers/theme_provider.dart';

// ============================================================
// WIDGET: CountryPicker
// Pemilih negara di Beranda: Semua / Jepang / Eropa.
// Memilih negara = mengganti tema SELURUH aplikasi secara
// global lewat ThemeProvider.
// ============================================================

class CountryPicker extends StatelessWidget {
  final ThemeProvider themeProvider;

  const CountryPicker({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder: chip ikut berubah saat tema berubah
    // dari tempat lain (misal dari halaman detail mobil).
    return AnimatedBuilder(
      animation: themeProvider,
      builder: (context, child) {
        final selected = themeProvider.country;
        final theme = Theme.of(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Negara',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _countryChip(
                  context,
                  label: 'Semua',
                  isSelected: selected == null,
                  onTap: () => themeProvider.selectCountry(null),
                ),
                const SizedBox(width: 8),
                _countryChip(
                  context,
                  label: '🇯🇵 Jepang',
                  isSelected: selected == Country.jepang,
                  onTap: () => themeProvider.selectCountry(Country.jepang),
                ),
                const SizedBox(width: 8),
                _countryChip(
                  context,
                  label: '🇪🇺 Eropa',
                  isSelected: selected == Country.eropa,
                  onTap: () => themeProvider.selectCountry(Country.eropa),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tema aktif: ${themeProvider.themeName} — ${themeProvider.themeTagline}',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _countryChip(
    BuildContext context, {
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
