// ============================================================
// FORMAT: fungsi bantuan untuk menampilkan angka.
// Supaya harga dan kilometer tampil rapi di semua layar,
// contoh: 264000000 -> "Rp 264.000.000" dan "Rp 264 Jt".
// Tanpa package tambahan (tanpa intl), hanya Dart murni.
// ============================================================

// Kelompokkan angka per 3 digit dengan titik: 264000000 -> "264.000.000"
String formatNumber(int value) {
  final s = value.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
    buffer.write(s[i]);
  }
  return buffer.toString();
}

// Harga lengkap: 264000000 -> "Rp 264.000.000"
String formatRupiah(int value) => 'Rp ${formatNumber(value)}';

// Harga singkat untuk kartu: 264000000 -> "Rp 264 Jt",
// 1150000000 -> "Rp 1,15 M"
String formatRupiahSingkat(int value) {
  if (value >= 1000000000) {
    final m = value / 1000000000;
    return 'Rp ${_trimDecimal(m)} M';
  }
  if (value >= 1000000) {
    final jt = value / 1000000;
    return 'Rp ${_trimDecimal(jt)} Jt';
  }
  return formatRupiah(value);
}

// 1.5 -> "1,5" ; 1.0 -> "1" (koma ala Indonesia)
String _trimDecimal(double value) {
  final s = value.toStringAsFixed(2);
  final trimmed = s.endsWith('0')
      ? s.substring(0, s.length - 1)
      : s; // "1.50" -> "1.5"
  final noTrailingZero = trimmed.endsWith('.0')
      ? trimmed.substring(0, trimmed.length - 2)
      : trimmed; // "1.0" -> "1"
  return noTrailingZero.replaceAll('.', ',');
}

// Kilometer: 18500 -> "18.500 km" ; 0 -> "0 km"
String formatKm(int km) => '${formatNumber(km)} km';
