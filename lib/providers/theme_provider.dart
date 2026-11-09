import 'package:flutter/material.dart';

import '../models/car.dart';
import '../theme/country_theme.dart';

// ============================================================
// ThemeProvider = pengatur tema aplikasi.
// ChangeNotifier = class yang bisa memberi tahu (notify)
// widget lain saat datanya berubah, supaya layar digambar ulang.
// Tanpa package provider — hanya Flutter SDK saja.
// Dipakai di main.dart lewat AnimatedBuilder.
// ============================================================

class ThemeProvider extends ChangeNotifier {
  // Negara yang sedang aktif. null = tema default MauMobil.
  Country? _country;

  Country? get country => _country;

  // Nama tema yang sedang aktif, contoh: 'Jepang'
  String get themeName => themeForCountry(_country).name;

  // Slogan tema yang sedang aktif
  String get themeTagline => themeForCountry(_country).tagline;

  // ThemeData yang dipakai MaterialApp saat ini
  ThemeData get currentTheme => themeForCountry(_country).theme;

  // CountryTheme lengkap (warna dll) untuk dipakai widget lain
  CountryTheme get currentCountryTheme => themeForCountry(_country);

  // Pilih negara -> tema aplikasi berubah secara global.
  // Panggil ini dari CountryPicker, halaman merek, dan detail mobil.
  void selectCountry(Country? country) {
    if (_country == country) return; // Sudah tema itu, tidak perlu berubah
    _country = country;
    notifyListeners(); // Beri tahu semua pendengar: tema berubah!
  }

  // Terapkan tema sesuai negara asal mobil yang dibuka.
  void applyCar(Car car) => selectCountry(car.country);
}
