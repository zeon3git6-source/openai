import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.onShowActions,
  });

  final Message message;
  final VoidCallback? onShowActions;

  @override
  Widget build(BuildContext context) {
    final alignment = message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = message.isUser
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surfaceVariant;
    final textColor = message.isUser ? Colors.white : Colors.black87;

    Widget bubble = Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(message.isUser ? 20 : 6),
          bottomRight: Radius.circular(message.isUser ? 6 : 20),
        ),
      ),
      child: Text(message.text, style: TextStyle(color: textColor, height: 1.4)),
    );

    if (!message.isUser && onShowActions != null) {
      bubble = GestureDetector(
        onLongPress: onShowActions,
        onSecondaryTap: onShowActions,
        child: bubble,
      );
    }

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: bubble,
      ),
    );
  }
}
