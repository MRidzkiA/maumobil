import 'package:flutter/material.dart';

import '../models/car.dart';
import '../models/chat_message.dart';

// ============================================================
// AppState = data aplikasi yang berubah-ubah selama app dipakai:
// - Mobil favorit
// - Mobil yang dipilih untuk dibandingkan (maks 3)
// - Iklan yang dipasang pengguna lewat form Jual Mobil
//
// ChangeNotifier: setiap perubahan memanggil notifyListeners()
// supaya layar yang mendengarkan ikut diperbarui.
// Data ini hanya tersimpan di memori (hilang saat app ditutup),
// karena MVP belum memakai database / server.
// ============================================================

class AppState extends ChangeNotifier {
  // ID mobil favorit (pakai Set supaya tidak ada duplikat)
  final Set<String> _favoriteIds = <String>{};

  // ID mobil untuk dibandingkan, urut sesuai pilihan (maks 3)
  final List<String> _compareIds = <String>[];

  // Iklan yang dipasang pengguna sendiri
  final List<Car> _myListings = <Car>[];

  // Pesan chat per mobil (kunci = id mobil). Simulasi lokal:
  // hanya tersimpan di memori, penjual membalas otomatis.
  final Map<String, List<ChatMessage>> _messagesByCar = <String, List<ChatMessage>>{};

  // Balasan otomatis penjual (diputar bergantian).
  static const List<String> _sellerReplies = [
    'Halo! Terima kasih sudah menghubungi. Mobilnya masih tersedia.',
    'Bisa, silakan datang untuk test drive. Kapan enaknya?',
    'Harga masih bisa nego sedikit kalau serius.',
    'Surat-surat lengkap, pajak hidup. Tenang saja.',
    'Boleh, saya kirim foto dan video detail mobilnya ya.',
  ];

  List<String> get favoriteIds => _favoriteIds.toList();
  List<String> get compareIds => List.unmodifiable(_compareIds);
  List<Car> get myListings => List.unmodifiable(_myListings);

  List<ChatMessage> messagesFor(String carId) =>
      List.unmodifiable(_messagesByCar[carId] ?? const []);

  int get favoriteCount => _favoriteIds.length;
  int get compareCount => _compareIds.length;

  // ---------- Favorit ----------
  bool isFavorite(String carId) => _favoriteIds.contains(carId);

  void toggleFavorite(String carId) {
    if (_favoriteIds.contains(carId)) {
      _favoriteIds.remove(carId);
    } else {
      _favoriteIds.add(carId);
    }
    notifyListeners();
  }

  // ---------- Bandingkan (maks 3 mobil) ----------
  bool isInCompare(String carId) => _compareIds.contains(carId);

  // Mengembalikan true kalau berhasil (ditambah / dihapus),
  // false kalau gagal karena sudah 3 mobil.
  bool toggleCompare(String carId) {
    if (_compareIds.contains(carId)) {
      _compareIds.remove(carId);
      notifyListeners();
      return true;
    }
    if (_compareIds.length >= 3) return false;
    _compareIds.add(carId);
    notifyListeners();
    return true;
  }

  void removeFromCompare(String carId) {
    _compareIds.remove(carId);
    notifyListeners();
  }

  void clearCompare() {
    _compareIds.clear();
    notifyListeners();
  }

  // ---------- Iklan Saya ----------
  void addListing(Car car) {
    _myListings.add(car);
    notifyListeners();
  }

  void removeListing(String carId) {
    _myListings.removeWhere((car) => car.id == carId);
    notifyListeners();
  }

  // ---------- Chat (simulasi lokal) ----------
  // Sapaan awal penjual saat chat pertama kali dibuka.
  void ensureGreeting(Car car) {
    final list = _messagesByCar.putIfAbsent(car.id, () => []);
    if (list.isEmpty) {
      list.add(
        ChatMessage(
          sender: ChatSender.seller,
          text:
              'Halo! Saya ${car.seller}. Ada yang bisa dibantu tentang ${car.brand} ${car.model}?',
          time: DateTime.now(),
        ),
      );
      notifyListeners();
    }
  }

  // Kirim pesan pengguna, lalu penjual membalas otomatis.
  void sendMessage(String carId, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final list = _messagesByCar.putIfAbsent(carId, () => []);
    list.add(
      ChatMessage(
        sender: ChatSender.user,
        text: trimmed,
        time: DateTime.now(),
      ),
    );
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 1200), () {
      final reply =
          _sellerReplies[list.length % _sellerReplies.length];
      list.add(
        ChatMessage(
          sender: ChatSender.seller,
          text: reply,
          time: DateTime.now(),
        ),
      );
      notifyListeners();
    });
  }
}
