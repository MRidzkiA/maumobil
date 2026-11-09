// ============================================================
// MODEL: Car (Mobil)
// Model = cetakan data. Di sini kita simpan data satu mobil.
// ============================================================

// Negara asal mobil. Inilah yang menentukan tema aplikasi:
// mobil Jepang -> tema Jepang, mobil Eropa -> tema Eropa.
// enum = pilihan tetap, supaya tidak salah ketik string.
enum Country { jepang, eropa }

// Extension = tambahan fungsi untuk enum di atas.
// Dipakai untuk mengubah negara jadi teks dan kode singkat.
extension CountryExtension on Country {
  // Teks yang tampil di layar, contoh: "Jepang"
  String get label {
    switch (this) {
      case Country.jepang:
        return 'Jepang';
      case Country.eropa:
        return 'Eropa';
    }
  }

  // Kode singkat untuk chip, contoh: "JP" atau "EU"
  String get code {
    switch (this) {
      case Country.jepang:
        return 'JP';
      case Country.eropa:
        return 'EU';
    }
  }
}

// Kondisi mobil: baru atau bekas.
enum CarCondition { baru, bekas }

extension CarConditionExtension on CarCondition {
  String get label {
    switch (this) {
      case CarCondition.baru:
        return 'Baru';
      case CarCondition.bekas:
        return 'Bekas';
    }
  }
}

// Class Car = satu mobil yang dijual di MauMobil.
class Car {
  final String id; // Contoh: 'avanza'
  final String brand; // Contoh: 'Toyota'
  final String model; // Contoh: 'Avanza'
  final Country country; // Jepang atau Eropa
  final int year; // Tahun pembuatan, contoh: 2024
  final int price; // Harga dalam Rupiah, contoh: 264000000
  final CarCondition condition; // baru / bekas
  final int kilometer; // 0 untuk mobil baru
  final String transmission; // 'Otomatis', 'Manual', atau 'CVT'
  final String fuel; // 'Bensin', 'Hybrid', atau 'Diesel'
  final String engine; // Contoh: '1.5L'
  final String color; // Warna mobil, contoh: 'Putih'
  final String location; // Contoh: 'Jakarta Selatan'
  final String seller; // Nama penjual / dealer
  final String description; // Deskripsi singkat mobil
  final String imageUrl; // URL foto asli mobil ('' = belum ada foto)

  // Constructor const: semua data wajib diisi saat membuat Car.
  const Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.country,
    required this.year,
    required this.price,
    required this.condition,
    required this.kilometer,
    required this.transmission,
    required this.fuel,
    required this.engine,
    required this.color,
    required this.location,
    required this.seller,
    required this.description,
    this.imageUrl = '',
  });
}
