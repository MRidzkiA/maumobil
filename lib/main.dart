import 'package:flutter/material.dart';

// Provider (state management tanpa package tambahan)
import 'providers/app_state.dart';
import 'providers/theme_provider.dart';

// Layar-layar tab bawah
import 'screens/car_list_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/sell_car_screen.dart';
import 'screens/splash_screen.dart';

// ============================================================
// main() = pintu masuk aplikasi.
// Flutter selalu mulai dari fungsi ini.
// ============================================================
void main() {
  runApp(MauMobilApp());
}

// MauMobilApp = widget utama aplikasi.
// Membuat ThemeProvider + AppState SEKALI di sini, lalu dipakai
// di semua layar lewat constructor (tanpa package provider).
// Stateful karena menampilkan SplashScreen sebentar di awal.
class MauMobilApp extends StatefulWidget {
  const MauMobilApp({super.key});

  @override
  State<MauMobilApp> createState() => _MauMobilAppState();
}

class _MauMobilAppState extends State<MauMobilApp> {
  final ThemeProvider themeProvider = ThemeProvider();
  final AppState appState = AppState();
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // Splash tampil 1,5 detik, lalu masuk ke layar utama.
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _showSplash = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder: MaterialApp digambar ulang setiap kali
    // tema berubah, supaya SELURUH aplikasi ikut berganti tema.
    // AnimatedTheme: perubahan tema berjalan mulus (animasi
    // warna ~350 ms) sehingga tidak berkedip saat ganti
    // tema Jepang / Eropa.
    return AnimatedBuilder(
      animation: themeProvider,
      builder: (context, child) {
        return MaterialApp(
          title: 'MauMobil',
          debugShowCheckedModeBanner: false, // Hilangkan tulisan DEBUG
          theme: themeProvider.currentTheme,
          home: AnimatedTheme(
            data: themeProvider.currentTheme,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            child: child!,
          ),
        );
      },
      // MainScreen / SplashScreen dibuat sekali di sini (child)
      // supaya tidak ikut dibuat ulang saat tema berubah.
      child: _showSplash
          ? const SplashScreen()
          : MainScreen(themeProvider: themeProvider, appState: appState),
    );
  }
}

// MainScreen = layar utama dengan Bottom Navigation (5 tab).
// StatefulWidget = widget yang datanya bisa berubah,
// di sini yang berubah adalah tab yang sedang dipilih.
class MainScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  final AppState appState;

  const MainScreen({
    super.key,
    required this.themeProvider,
    required this.appState,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // _selectedIndex = tab yang sedang aktif (0 sampai 4).
  int _selectedIndex = 0;

  // Judul AppBar berubah sesuai tab yang dipilih.
  static const List<String> _titles = [
    'MauMobil',
    'Cari Mobil',
    'Favorit',
    'Jual Mobil',
    'Profil',
  ];

  // Fungsi ini dipanggil saat user menekan tab bawah.
  // setState() = memberitahu Flutter untuk menggambar ulang layar.
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Daftar 5 layar untuk 5 tab bawah.
    // Dibuat di build() karena butuh themeProvider & appState.
    final List<Widget> screens = [
      HomeScreen(
        themeProvider: widget.themeProvider,
        appState: widget.appState,
      ),
      CarListScreen(
        themeProvider: widget.themeProvider,
        appState: widget.appState,
      ),
      FavoritesScreen(
        themeProvider: widget.themeProvider,
        appState: widget.appState,
      ),
      SellCarScreen(
        themeProvider: widget.themeProvider,
        appState: widget.appState,
      ),
      ProfileScreen(
        themeProvider: widget.themeProvider,
        appState: widget.appState,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
      ),
      // Tampilkan layar sesuai tab yang dipilih.
      body: screens[_selectedIndex],
      // BottomNavigationBar = menu bawah dengan 5 tab.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed, // Wajib untuk 5 tab
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Jual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
