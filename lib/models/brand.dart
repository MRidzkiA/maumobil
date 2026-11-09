import 'car.dart';

// ============================================================
// MODEL: Brand (Merek Mobil)
// ============================================================

// Class Brand = satu merek mobil, contoh: Toyota (Jepang).
class Brand {
  final String name; // Contoh: 'Toyota'
  final Country country; // Jepang atau Eropa
  final String tagline; // Slogan singkat merek
  final int founded; // Tahun merek berdiri

  const Brand({
    required this.name,
    required this.country,
    required this.tagline,
    required this.founded,
  });
}

// ============================================================
// DATA: Daftar semua merek (MVP: Jepang + Eropa dulu)
// Fase 2 nanti tambah: Korea (Hyundai, Kia), Amerika (Ford,
// Tesla, Chevrolet), dan China (Wuling, BYD, Chery).
// ============================================================
const List<Brand> brands = [
  Brand(
    name: 'Toyota',
    country: Country.jepang,
    tagline: 'Let\'s Go Places',
    founded: 1937,
  ),
  Brand(
    name: 'Honda',
    country: Country.jepang,
    tagline: 'The Power of Dreams',
    founded: 1948,
  ),
  Brand(
    name: 'Daihatsu',
    country: Country.jepang,
    tagline: 'Sahabat Keluarga Indonesia',
    founded: 1907,
  ),
  Brand(
    name: 'BMW',
    country: Country.eropa,
    tagline: 'Sheer Driving Pleasure',
    founded: 1916,
  ),
  Brand(
    name: 'Mercedes-Benz',
    country: Country.eropa,
    tagline: 'The Best or Nothing',
    founded: 1926,
  ),
  Brand(
    name: 'Audi',
    country: Country.eropa,
    tagline: 'Vorsprung durch Technik',
    founded: 1909,
  ),
];
