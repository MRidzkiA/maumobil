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
// Foto mobil: foto asli dari URL publik (lihat imageUrl tiap mobil).
// Foto dimuat dengan Image.network (lihat widgets/car_image.dart);
// kalau gagal dimuat (misal offline), tampil placeholder gradasi
// warna tema. Daftar sumber foto ada di README.md.
// ============================================================

const List<Car> cars = [
  // ---------------- JEPANG: Toyota ----------------
  Car(
    id: 'avanza',
    brand: 'Toyota',
    model: 'Avanza 1.5 G CVT',
    imageUrl:
        'https://www.autocom.mx/static/agency-go-virtual/Toyota/Avanza/2024/360-color-picker-1/color2/color2_3.jpg',
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
    imageUrl:
        'https://imgcdn.zigwheels.my/large/gallery/color/25/2007/toyota-innova-zenix-color-945696.jpg',
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
    imageUrl: 'https://apollo.olx.co.id/v1/files/69aba1110c264-ID/image',
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
    imageUrl:
        'https://www.vosshonda.com/assets/d4560/img/uagNqJ6MCJV7HFeuc9kmAJB2vzBBLMNmeUiYyL86.jpg',
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
    imageUrl:
        'https://cms-2023.daihatsu.co.id/cdn-cgi/image/w=700,q=85/assets/0bc65861-afa5-40d5-a277-fa76b6aab854',
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
    imageUrl:
        'https://cms-2023.daihatsu.co.id/cdn-cgi/image/w=700,q=85/assets/ac977e38-8ac2-4730-9f4f-b1b04f336b09',
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
    imageUrl:
        'https://img4.icarcdn.com/94825441/gallery_recon-car-carlist-bmw-3-series-320i-m-sport-sedan-malaysia_000094825441_c3779049_06b1_4819_8d35_992b21943388.jpg?smia=xTM',
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
    imageUrl:
        'https://motorgiga.com/uploads/marcas-modelos/versiones/bmw-x1-2023-estandar-estandar-x1-sdrive18d.jpg',
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
    imageUrl:
        'https://autouncle-public.s3.eu-west-1.amazonaws.com/de/car_images/d56eba19-ef21-4c39-a99b-2820d3cc8c70.jpg',
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
    imageUrl:
        'https://imprensa.mercedes-benz.com.br/storage/posts/7646f894d1465658b8597c89846d5276758f1c6e.jpg',
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
    imageUrl:
        'https://static0.carbuzzimages.com/wordpress/wp-content/uploads/2024/02/13979-43.jpg?w=1200&h=675&fit=crop',
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
    imageUrl:
        'https://images.carexpert.com.au/resize/800/-/cms/v1/media/2022-audi-q3-primary-image.jpg',
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
