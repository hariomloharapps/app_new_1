import 'package:flutter/material.dart';
import 'package:gyrogame/widgets/typing_indicator.dart';
import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment:
        message.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            message.isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: message.isSent
                        ? const Color(0xFF2C2C2E) // Dark gray for sent messages
                        : const Color(0xFF1C1C1E), // Darker gray for received messages
                    borderRadius: BorderRadius.circular(16).copyWith(
                      bottomRight: message.isSent ? const Radius.circular(4) : const Radius.circular(16),
                      bottomLeft: !message.isSent ? const Radius.circular(4) : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          color: message.isSent ? Colors.white : Colors.grey[300],
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 4,
                          right: message.isSent ? 2 : 0,
                          left: message.isSent ? 0 : 2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: message.isSent
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: message.isSent
            ? const Color(0xFF2C2C2E) // Dark gray for sent messages
            : const Color(0xFF1C1C1E), // Darker gray for received messages
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: message.isSent
            ? const Text(
          'You',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        )
            : Icon(
          Icons.android_rounded,
          size: 18,
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    IconData icon;
    Color color;

    switch (status) {
      case MessageStatus.sending:
        return SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
          ),
        );
      case MessageStatus.sent:
        icon = Icons.check;
        color = Colors.grey[500]!;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        color = Colors.grey[500]!;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = Colors.grey[300]!;
        break;
    }

    return Icon(
      icon,
      size: 14,
      color: color,
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}