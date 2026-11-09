// ============================================================
// MODEL: ChatMessage (satu pesan chat)
// Chat di MauMobil adalah simulasi lokal (prototipe):
// pesan hanya tersimpan di memori HP, belum ada server.
// ============================================================

enum ChatSender { user, seller }

class ChatMessage {
  final ChatSender sender;
  final String text;
  final DateTime time;

  const ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
  });
}
