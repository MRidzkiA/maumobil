# MauMobil

Aplikasi jual beli mobil baru dan bekas untuk pasar Indonesia, dibuat dengan **Flutter / Dart** untuk pemula yang belajar di **Android Studio**.

Nama project: `maumobil`

## Fitur Khas: Tema Dinamis per Negara

Inilah yang membedakan MauMobil dari marketplace mobil biasa. **Tema aplikasi berubah mengikuti negara asal mobil yang dipilih** — dan berlaku di **semua halaman** (AppBar, tombol, kartu, detail):

- **Jepang** (Toyota, Honda, Daihatsu) — merah `#C8102E`, putih, bersih dan minimalis
- **Eropa** (BMW, Mercedes-Benz, Audi) — navy gelap `#0B1F3A`, silver, emas, elegan

Tema berubah saat pengguna:
1. Memilih negara di pemilih negara di Beranda
2. Memilih filter negara di layar Cari
3. Membuka halaman merek
4. Membuka detail sebuah mobil

Belum memilih negara? Aplikasi memakai tema default MauMobil (teal gelap + oranye).

## Fitur (MVP)

1. **Beranda** — pencarian, pemilih negara (tema dinamis), banner tema aktif, merek populer, mobil rekomendasi.
2. **Cari** — filter kata kunci, negara, merek, kondisi (baru/bekas), harga maks, dan urutan (termurah / termahal / tahun terbaru).
3. **Halaman Merek** — info merek (slogan, tahun berdiri, negara) + semua mobil merek tersebut.
4. **Detail Mobil** — galeri placeholder, harga, spesifikasi lengkap, deskripsi, info penjual, tombol favorit, bandingkan, simulasi kredit, chat/telepon penjual (prototipe).
5. **Favorit** — simpan mobil yang disukai.
6. **Bandingkan** — bandingkan sampai 3 mobil dalam satu tabel (harga, tahun, kondisi, KM, transmisi, bahan bakar, mesin, warna, lokasi, negara).
7. **Simulasi Kredit** — input harga, DP, tenor (12–60 bulan), bunga (%/tahun) → cicilan per bulan dengan rumus anuitas.
8. **Jual Mobil** — form pasang iklan (merek, model, tahun, harga, kondisi, KM, transmisi, bahan bakar, mesin, warna, lokasi, penjual, deskripsi). Iklan langsung muncul di Cari, Merek, dan Profil.
9. **Profil** — info pengguna, statistik iklan & favorit, daftar "Iklan Saya" (bisa dihapus), daftar favorit.
10. **Bottom Navigation** — Beranda, Cari, Favorit, Jual, Profil.

Tidak ada package tambahan. Hanya Flutter SDK + `cupertino_icons`, jadi bisa jalan offline. State management memakai `ChangeNotifier` + `AnimatedBuilder` bawaan Flutter SDK (tanpa package `provider`).

## Katalog (MVP)

6 merek, 12 mobil (2 model per merek) — Jepang + Eropa dulu:

| Negara | Merek | Model |
|---|---|---|
| Jepang | Toyota | Avanza 1.5 G CVT (baru), Innova Zenix 2.0 G HV (baru) |
| Jepang | Honda | Brio Satya 1.2 E CVT (baru), CR-V 1.5 Turbo Prestige (bekas) |
| Jepang | Daihatsu | Ayla 1.2 R (baru), Terios R 1.5 (bekas) |
| Eropa | BMW | 320i Sport (baru), X1 sDrive18i (bekas) |
| Eropa | Mercedes-Benz | C200 AMG Line (baru), GLA 200 AMG Line (bekas) |
| Eropa | Audi | A4 2.0 TFSI (baru), Q3 1.4 TFSI (bekas) |

## Struktur Folder

```text
maumobil/
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
├── .gitignore
└── lib/
    ├── main.dart                        # Pintu masuk app + Bottom Navigation (5 tab)
    ├── models/
    │   ├── car.dart                     # Model Car + enum Country & CarCondition
    │   └── brand.dart                   # Model Brand + daftar 6 merek
    ├── data/
    │   └── cars.dart                    # Katalog 12 mobil (HARGA PERKIRAAN)
    ├── theme/
    │   └── country_theme.dart           # ThemeData Jepang, Eropa, dan default
    ├── providers/
    │   ├── theme_provider.dart          # ThemeProvider (ChangeNotifier)
    │   └── app_state.dart               # AppState: favorit, bandingkan, iklan saya
    ├── utils/
    │   └── format.dart                  # Format Rupiah & kilometer
    ├── widgets/
    │   ├── car_card.dart                # Kartu mobil (dipakai di banyak layar)
    │   └── country_picker.dart          # Pemilih negara (pengganti tema)
    └── screens/
        ├── home_screen.dart             # Beranda
        ├── car_list_screen.dart         # Cari + filter
        ├── brand_screen.dart            # Halaman merek
        ├── car_detail_screen.dart       # Detail mobil
        ├── favorites_screen.dart        # Favorit
        ├── compare_screen.dart          # Bandingkan (tabel)
        ├── credit_simulator_screen.dart # Simulasi kredit (anuitas)
        ├── sell_car_screen.dart         # Form jual mobil
        └── profile_screen.dart          # Profil + Iklan Saya
```

> Folder `android/` dan `ios/` **tidak disertakan** di sini. Folder itu dibuat otomatis oleh `flutter create` di langkah di bawah.

## Cara Menjalankan di Android Studio (Langkah demi Langkah)

### 1. Pastikan Flutter sudah terpasang

Di terminal, cek:

```bash
flutter doctor
```

Kalau belum ada Flutter SDK, install dulu, lalu install plugin **Flutter** dan **Dart** di Android Studio: `Settings > Plugins`.

### 2. Buat project baru di Android Studio

Pilih **New Flutter Project**, isi:

- Project name: `maumobil`
- Project location: pilih folder tempat kamu menyimpan project
- Klik **Create**

Android Studio akan membuat folder `android/`, `ios/`, `lib/`, dan `pubspec.yaml` bawaan.

### 3. Salin file dari project ini

Salin dan ganti (overwrite) file berikut dari folder `maumobil/` ini ke project barumu:

- `pubspec.yaml` → ganti `pubspec.yaml` bawaan
- Semua isi folder `lib/` → ganti isi folder `lib/` bawaan

Jangan salin folder `android/` atau `ios/`, karena itu sudah dibuat otomatis di langkah 2.

### 4. Ambil package dan jalankan

Di terminal Android Studio (di dalam folder project baru):

```bash
flutter pub get
flutter run
```

Atau klik tombol **Run ▶** di Android Studio.

Pilih emulator atau HP Android yang sudah disambungkan (nyalakan **USB Debugging** di HP).

## Cara Menambah Mobil Baru

Buka `lib/data/cars.dart`, cari daftar `cars`, lalu tambah satu `Car` baru di dalam list, contoh:

```dart
Car(
  id: 'yaris',
  brand: 'Toyota',
  model: 'Yaris Cross 1.5 G',
  country: Country.jepang,
  year: 2024,
  price: 360000000,
  condition: CarCondition.baru,
  kilometer: 0,
  transmission: 'CVT',
  fuel: 'Hybrid',
  engine: '1.5L Hybrid',
  color: 'Putih',
  location: 'Jakarta Selatan',
  seller: 'Toyota Auto2000',
  description: 'SUV kompak hybrid yang irit dan stylish.',
),
```

`country` hanya boleh `Country.jepang` atau `Country.eropa` (tema otomatis mengikuti). `condition` hanya boleh `CarCondition.baru` atau `CarCondition.bekas`.

## Cara Menambah Negara Baru (misal Korea)

1. Tambah nilai baru di `enum Country` di `lib/models/car.dart`, contoh: `korea`.
2. Tambah label + kode di `CountryExtension` di file yang sama.
3. Buat tema baru di `lib/theme/country_theme.dart` (contoh: `koreaTheme`) dan daftarkan di `themeForCountry()`.
4. Tambah merek Korea di `lib/models/brand.dart` dan mobilnya di `lib/data/cars.dart`.
5. Tambah chip negara di `lib/widgets/country_picker.dart` dan `lib/screens/car_list_screen.dart`.

## Konsep yang Bisa Dipelajari dari Kode Ini

- `StatelessWidget` vs `StatefulWidget`
- `ChangeNotifier` + `AnimatedBuilder` untuk state management tanpa package
- `ThemeData` dan `ColorScheme` — tema dinamis yang berubah saat runtime
- `Navigator.push` untuk pindah ke layar detail
- `ListView.builder` dan `DataTable` untuk daftar dan tabel
- `Form` + `TextFormField` + validator untuk form
- `DropdownButtonFormField` dan `RadioListTile`
- Rumus anuitas untuk simulasi kredit
- Memisahkan data (model + data) dari tampilan (screen) dan tema

## Catatan Penting (Prototipe)

- **Harga adalah PERKIRAAN untuk prototipe**, bukan harga resmi dealer/pabrikan. Harga asli bisa berbeda tergantung kota, promo, kondisi mobil, dan waktu. Lihat komentar di `lib/data/cars.dart`.
- **Foto mobil belum ada.** Tampilan memakai placeholder gradasi warna tema + ikon mobil + nama model. Foto asli perlu ditambahkan nanti (aset berlisensi atau foto listing nyata).
- **Iklan yang dipasang lewat tab Jual hanya tersimpan di memori HP** dan hilang saat aplikasi ditutup. Belum ada database/server di MVP ini.
- **Chat dan telepon penjual masih prototipe** (menampilkan pesan "segera hadir").
- **MySQL sudah tersedia untuk pengembangan lanjutan** — Ridzki punya server MySQL sendiri di port 3308 yang boleh dipakai kalau aplikasi butuh backend. Alamat host dan nama database belum diberikan; saat backend dibutuhkan, sambungkan API ke MySQL tersebut (aplikasi Flutter tidak terhubung langsung ke MySQL, melainkan lewat API/REST di server).

## Rencana Fase 2 (dari riset Raka)

- Tambah negara: Korea (Hyundai, Kia), Amerika (Ford, Tesla, Chevrolet), China (Wuling, BYD, Chery)
- Estimasi harga pasar (Cek Harga) + penanda harga wajar/mahal
- Riwayat mobil (bekas kecelakaan/banjir) — butuh mitra data
- Booking inspeksi & test drive, tukar tambah
- Rekomendasi AI ("mobil yang cocok untuk budget kamu")
- Notifikasi harga turun & pencarian tersimpan
- Verified seller + rating/ulasan penjual
- Galeri foto 360° / video
- Backend + API (MySQL di port 3308) untuk listing nyata, login, chat, dan pembayaran

Laporan riset lengkap: `../superapp-mobil/riset-fitur-raka.md`
