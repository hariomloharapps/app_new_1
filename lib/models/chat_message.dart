
// lib/models/chat_message.dart
import 'package:flutter/material.dart';

enum MessageStatus { sending, sent, delivered, read }

class ChatMessage {
  final String id;
  final String text;
  final bool isSent;
  final DateTime timestamp;
  final MessageStatus status;

  ChatMessage({
    required this.text,
    required this.isSent,
    required this.timestamp,
    this.status = MessageStatus.sending,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();
}
