import 'package:flutter/material.dart';

import '../models/car.dart';
import '../models/chat_message.dart';
import '../providers/app_state.dart';
import '../utils/format.dart';

// ============================================================
// LAYAR: ChatScreen (chat dengan penjual)
// Chat simulasi lokal (prototipe): pesan tersimpan di memori
// HP lewat AppState, penjual membalas otomatis setelah
// beberapa detik. Belum ada server / nomor telepon asli.
// ============================================================

class ChatScreen extends StatefulWidget {
  final Car car;
  final AppState appState;

  const ChatScreen({
    super.key,
    required this.car,
    required this.appState,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _lastCount = 0;

  @override
  void initState() {
    super.initState();
    // Sapaan awal penjual saat chat pertama kali dibuka.
    widget.appState.ensureGreeting(widget.car);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _send() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    widget.appState.sendMessage(widget.car.id, text);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Text(
                car.seller[0],
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.seller,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${car.brand} ${car.model}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ---------- Daftar pesan ----------
          Expanded(
            child: AnimatedBuilder(
              animation: widget.appState,
              builder: (context, child) {
                final messages = widget.appState.messagesFor(car.id);
                // Geser ke pesan terbaru saat ada pesan masuk.
                if (messages.length != _lastCount) {
                  _lastCount = messages.length;
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _bubble(context, messages[index]);
                  },
                );
              },
            ),
          ),

          // ---------- Info harga singkat ----------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Text(
              '${car.brand} ${car.model} • ${formatRupiah(car.price)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ---------- Kolom ketik ----------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan untuk penjual...',
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _send,
                      tooltip: 'Kirim pesan',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Satu gelembung pesan: kanan = saya, kiri = penjual.
  Widget _bubble(BuildContext context, ChatMessage message) {
    final isMine = message.sender == ChatSender.user;
    final theme = Theme.of(context);
    final time =
        '${message.time.hour.toString().padLeft(2, '0')}:${message.time.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? theme.colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: isMine ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: TextStyle(
                fontSize: 10,
                color: isMine ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
