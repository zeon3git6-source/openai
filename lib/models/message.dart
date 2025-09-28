class Message {
  Message({
    required this.id,
    required this.text,
    required this.isUser,
    this.timestamp,
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime? timestamp;
}
