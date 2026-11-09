import 'package:flutter/material.dart';

import '../providers/app_state.dart';

// ============================================================
// WIDGET: FavoriteButton
// Tombol hati dengan micro-interaction: ikon membesar sesaat
// (animasi pop) setiap kali ditekan, lalu kembali normal.
// Keadaan favorit dibaca dari AppState supaya selalu sinkron
// di semua layar (kartu, detail, tab Favorit).
// ============================================================

class FavoriteButton extends StatefulWidget {
  final AppState appState;
  final String carId;
  final double size;
  final Color color; // Warna ikon saat belum favorit
  final Color activeColor; // Warna ikon saat sudah favorit

  const FavoriteButton({
    super.key,
    required this.appState,
    required this.carId,
    this.size = 24,
    this.color = Colors.grey,
    this.activeColor = Colors.red,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    widget.appState.toggleFavorite(widget.carId);
    // Animasi pop: membesar lalu mengecil lagi.
    _controller.forward().whenComplete(() {
      if (mounted) _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, child) {
        final isFavorite = widget.appState.isFavorite(widget.carId);
        return ScaleTransition(
          scale: _scale,
          child: IconButton(
            onPressed: _onTap,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? widget.activeColor : widget.color,
              size: widget.size,
            ),
            tooltip: isFavorite ? 'Hapus dari favorit' : 'Simpan ke favorit',
          ),
        );
      },
    );
  }
}
