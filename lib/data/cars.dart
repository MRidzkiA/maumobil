import '../models/car.dart';

// ============================================================
// DATA: Daftar semua mobil (MVP: 6 merek, 12 mobil)
// Jepang: Toyota, Honda, Daihatsu (2 model per merek)
// Eropa: BMW, Mercedes-Benz, Audi (2 model per merek)
// ============================================================
//
// PENTING — HARGA PERKIRAAN UNTUK PROTOTIPE:
// Semua harga di bawah ini adalah PERKIRAAN harga pasaran di
// Indonesia (periode 2025-2026), BUKAN harga resmi dari dealer
// atau pabrikan. Harga asli bisa berbeda tergantung kota,
// promo, kondisi mobil, dan waktu. Jangan jadikan harga ini
// sebagai patokan jual beli sungguhan. Untuk versi produksi,
// harga harus diambil dari sumber data resmi yang diperbarui.
//
// Foto mobil: belum ada foto asli. Tampilan memakai placeholder
// gradasi warna tema + nama model (lihat CarCard).
// ============================================================

const List<Car> cars = [
  // ---------------- JEPANG: Toyota ----------------
  Car(
    id: 'avanza',
    brand: 'Toyota',
    model: 'Avanza 1.5 G CVT',
    country: Country.jepang,
    year: 2024,
    price: 264000000,
    condition: CarCondition.baru,
    kilometer: 0,
    transmission: 'CVT',
    fuel: 'Bensin',
    engine: '1.5L',
    color: 'Putih',
    location: 'Jakarta Selatan',
    seller: 'Toyota Auto2000 Cilandak',
    description:
        'MPV keluarga paling laris di Indonesia. Irit, kabin lega 7 penumpang, '
        'dan mudah dirawat. Cocok untuk harian maupun perjalanan jauh bersama keluarga.',
  ),
  Car(
    id: 'zenix',
    brand: 'Toyota',
    model: 'Innova Zenix 2.0 G HV',
    country: Country.jepang,
    year: 2024,
    price: 471000000,
    condition: CarCondition.baru,
    kilometer: 0,
    transmission: 'CVT',
    fuel: 'Hybrid',
    engine: '2.0L Hybrid',
    color: 'Hitam',
    location: 'Jakarta Timur',
    seller: 'Toyota Astrido',
    description:
        'Innova generasi terbaru dengan mesin hybrid yang irit dan bertenaga. '
        'Kabin senyaman sedan, fitur keselamatan Toyota Safety Sense lengkap.',
  ),

  // ---------------- JEPANG: Honda ----------------
  Car(
    id: 'brio',
    brand: 'Honda',
    model: 'Brio Satya 1.2 E CVT',
    country: Country.jepang,
    year: 2024,
    price: 196000000,
    condition: CarCondition.baru,
    kilometer: 0,
    transmission: 'CVT',
    fuel: 'Bensin',
    engine: '1.2L',
    color: 'Merah',
    location: 'Tangerang',
    seller: 'Honda Bintang',
    description:
        'City car mungil yang lincah di jalanan kota dan sangat irit BBM. '
        'Pilihan favorit anak muda dan mobil pertama keluarga.',
  ),
  Car(
    id: 'crv',
    brand: 'Honda',
    model: 'CR-V 1.5 Turbo Prestige',
    country: Country.jepang,
    year: 2023,
    price: 525000000,
    condition: CarCondition.bekas,
    kilometer: 18500,
    transmission: 'CVT',
    fuel: 'Bensin',
    engine: '1.5L Turbo',
    color: 'Putih',
    location: 'Bandung',
    seller: 'Budi Santoso',
    description:
        'SUV premium Honda dengan mesin turbo yang responsif. Kondisi terawat, '
        'servis rutin di bengkel resmi, pajak panjang. Tangan pertama dari baru.',
  ),

  // ---------------- JEPANG: Daihatsu ----------------
  Car(
    id: 'ayla',
    brand: 'Daihatsu',
    model: 'Ayla 1.2 R',
    country: Country.jepang,
    year: 2024,
    price: 171000000,
    condition: CarCondition.baru,
    kilometer: 0,
    transmission: 'Otomatis',
    fuel: 'Bensin',
    engine: '1.2L',
    color: 'Kuning',
    location: 'Bekasi',
    seller: 'Astra Daihatsu',
    description:
        'LCGC paling terjangkau dengan fitur lengkap di kelasnya. Irit, '
        'praktis, dan biaya perawatan sangat murah. Pas untuk mobil pertama.',
  ),
  Car(
    id: 'terios',
    brand: 'Daihatsu',
    model: 'Terios R 1.5',
    country: Country.jepang,
    year: 2022,
    price: 218000000,
    condition: CarCondition.bekas,
    kilometer: 32000,
    transmission: 'Otomatis',
    fuel: 'Bensin',
    engine: '1.5L',
    color: 'Silver',
    location: 'Depok',
    seller: 'Agus Wijaya',
    description:
        'SUV 7 penumpang yang tangguh di segala medan. Mesin bandel, '
        'kaki-kaki masih enak, interior bersih. Siap pakai, tinggal gas.',
  ),

  // ---------------- EROPA: BMW ----------------
  Car(
    id: 'bmw320i',
    brand: 'BMW',
    model: '320i Sport',
    country: Country.eropa,
    year: 2023,
    price: 980000000,
    condition: CarCondition.baru,
    kilometer: 0,
    transmission: 'Otomatis',
    fuel: 'Bensin',
    engine: '2.0L Turbo',
    color: 'Biru',
    location: 'Jakarta Selatan',
    seller: 'BMW Astra',
    description:
        'Sedan sport legendaris dengan handling khas BMW. Mesin 2.0L turbo '
        'bertenaga 184 hp, interior mewah, dan teknologi iDrive terbaru.',
  ),
  Car(
    id: 'bmwx1',
    brand: 'BMW',
    model: 'X1 sDrive18i',
    country: Country.eropa,
    year: 2022,
    price: 715000000,
    condition: CarCondition.bekas,
    kilometer: 21000,
    transmission: 'Otomatis',
    fuel: 'Bensin',
    engine: '1.5L Turbo',
    color: 'Putih',
    location: 'Jakarta Pusat',
    seller: 'Sinta Maharani',
    description:
        'SUV kompak premium dengan posisi duduk tinggi dan kabin lapang. '
        'Riwayat servis lengkap di bengkel resmi BMW. Kondisi seperti baru.',
  ),

  // ---------------- EROPA: Mercedes-Benz ----------------
  Car(
    id: 'c200',
    brand: 'Mercedes-Benz',
    model: 'C200 AMG Line',
    country: Country.eropa,
    year: 2023,
    price: 1050000000,
    condition: CarCondition.baru,
    kilometer: 0,
    transmission: 'Otomatis',
    fuel: 'Bensin',
    engine: '1.5L Turbo',
    color: 'Hitam',
    location: 'Jakarta Selatan',
    seller: 'Mercedes-Benz Citra',
    description:
        'Sedan eksekutif dengan paket AMG Line yang sporty. Kabin mewah '
        'dengan ambient lighting 64 warna dan layar MBUX yang futuristik.',
  ),
  Car(
    id: 'gla200',
    brand: 'Mercedes-Benz',
    model: 'GLA 200 AMG Line',
    country: Country.eropa,
    year: 2022,
    price: 765000000,
    condition: CarCondition.bekas,
    kilometer: 25400,
    transmission: 'Otomatis',
    fuel: 'Bensin',
    engine: '1.3L Turbo',
    color: 'Abu-abu',
    location: 'Surabaya',
    seller: 'Dewi Lestari',
    description:
        'SUV kompak Mercy yang stylish dan nyaman dipakai harian. '
        'Ban baru, aki baru, semua fitur berfungsi normal. Pajak hidup.',
  ),

  // ---------------- EROPA: Audi ----------------
  Car(
    id: 'a4',
    brand: 'Audi',
    model: 'A4 2.0 TFSI',
    country: Country.eropa,
    year: 2023,
    price: 1150000000,
    condition: CarCondition.baru,
    kilometer: 0,
    transmission: 'Otomatis',
    fuel: 'Bensin',
    engine: '2.0L Turbo',
    color: 'Merah',
    location: 'Jakarta Utara',
    seller: 'Audi Garuda',
    description:
        'Sedan premium Audi dengan teknologi quattro dan virtual cockpit. '
        'Desain elegan, kedap suara, dan sangat nyaman untuk perjalanan jauh.',
  ),
  Car(
    id: 'q3',
    brand: 'Audi',
    model: 'Q3 1.4 TFSI',
    country: Country.eropa,
    year: 2022,
    price: 690000000,
    condition: CarCondition.bekas,
    kilometer: 28000,
    transmission: 'Otomatis',
    fuel: 'Bensin',
    engine: '1.4L Turbo',
    color: 'Putih',
    location: 'Yogyakarta',
    seller: 'Eko Prasetyo',
    description:
        'SUV Audi yang kompak tapi tetap terasa premium. Mesin TFSI irit '
        'dan bertenaga. Cocok untuk keluarga muda yang mau naik kelas.',
  ),
];
