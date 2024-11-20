
// lib/services/chat_service.dart
import '../models/chat_message.dart';

class ChatService {
  static Future<void> sendMessage(ChatMessage message) async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
  }

  static Stream<MessageStatus> getMessageStatus(String messageId) async* {
    await Future.delayed(const Duration(milliseconds: 500));
    yield MessageStatus.sent;
    await Future.delayed(const Duration(milliseconds: 500));
    yield MessageStatus.delivered;
    await Future.delayed(const Duration(milliseconds: 500));
    yield MessageStatus.read;
  }
}