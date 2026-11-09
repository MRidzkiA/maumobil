import 'package:flutter/material.dart';

import '../models/car.dart';

// ============================================================
// TEMA DINAMIS PER NEGARA — fitur khas MauMobil.
// Setiap negara punya satu CountryTheme: warna utama, warna
// aksen, warna background, dan slogan. Saat pengguna memilih
// negara / merek / mobil, ThemeProvider mengganti tema ini
// dan SELURUH aplikasi ikut berubah (AppBar, tombol, kartu).
// ============================================================

class CountryTheme {
  final String name; // Contoh: 'Jepang'
  final String tagline; // Slogan tema, contoh: 'Bersih, rapi, dan presisi'
  final Color primary; // Warna utama (AppBar, tombol)
  final Color accent; // Warna aksen (gradasi, chip)
  final Color background; // Warna latar layar
  final Color surface; // Warna kartu
  final Color onPrimary; // Warna teks di atas warna utama

  const CountryTheme({
    required this.name,
    required this.tagline,
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.onPrimary,
  });

  // Ubah CountryTheme jadi ThemeData yang dipakai MaterialApp.
  ThemeData get theme {
    final scheme = ColorScheme.light(
      primary: primary,
      secondary: accent,
      surface: surface,
      onPrimary: onPrimary,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      // AppBar rata (tanpa bayangan) — kesan bersih dan minimalis.
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
      ),
      // Kartu: bayangan sangat halus, sudut membulat lembut.
      cardTheme: CardThemeData(
        color: surface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      // Input: latar putih, sudut membulat, border tipis.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ------------------------------------------------------------
// Tema default (belum pilih negara): warna khas MauMobil.
// ------------------------------------------------------------
const CountryTheme defaultTheme = CountryTheme(
  name: 'MauMobil',
  tagline: 'Cari mobil impianmu',
  primary: Color(0xFF0F4C5C), // Teal gelap
  accent: Color(0xFFFB8B24), // Oranye
  background: Color(0xFFF7F7F5),
  surface: Colors.white,
  onPrimary: Colors.white,
);

// ------------------------------------------------------------
// Tema Jepang: merah bendera Jepang (#C8102E), putih,
// bersih dan minimalis.
// ------------------------------------------------------------
const CountryTheme japanTheme = CountryTheme(
  name: 'Jepang',
  tagline: 'Bersih, rapi, dan presisi',
  primary: Color(0xFFC8102E), // Merah Jepang
  accent: Color(0xFFFFB7C5), // Sakura pink
  background: Color(0xFFFFF8F8),
  surface: Colors.white,
  onPrimary: Colors.white,
);

// ------------------------------------------------------------
// Tema Eropa: navy gelap (#0B1F3A), silver, emas — elegan.
// ------------------------------------------------------------
const CountryTheme europeTheme = CountryTheme(
  name: 'Eropa',
  tagline: 'Elegan dan berkelas',
  primary: Color(0xFF0B1F3A), // Navy gelap
  accent: Color(0xFFC9A227), // Emas
  background: Color(0xFFF4F6F8),
  surface: Colors.white,
  onPrimary: Colors.white,
);

// Cari tema berdasarkan negara. null = tema default.
CountryTheme themeForCountry(Country? country) {
  switch (country) {
    case Country.jepang:
      return japanTheme;
    case Country.eropa:
      return europeTheme;
    case null:
      return defaultTheme;
  }
}
