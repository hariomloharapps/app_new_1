import 'package:flutter/material.dart';

class MessageComposer extends StatefulWidget {
  final Function(String) onSubmitted;
  final bool canSend; // Changed from isWaitingForResponse to more direct canSend

  const MessageComposer({
    required this.onSubmitted,
    required this.canSend, // If true, user can send. If false, send is blocked
  });

  @override
  _MessageComposerState createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final TextEditingController _messageController = TextEditingController();
  bool _hasText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: TextField(
                controller: _messageController,
                onChanged: (text) {
                  setState(() {
                    _hasText = text.trim().isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: widget.canSend
                      ? 'Type a message'
                      : 'Waiting for response...',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    final bool canSendNow = _hasText && widget.canSend;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: canSendNow
                ? const Color(0xFF007AFF)
                : const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: canSendNow
                  ? () {
                widget.onSubmitted(_messageController.text);
                _messageController.clear();
                setState(() => _hasText = false);
              }
                  : null,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.send_rounded,
                  color: canSendNow
                      ? Colors.white
                      : Colors.grey[600],
                  size: 24,
                ),
              ),
            ),
          ),
        ),
        if (!widget.canSend && _hasText)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}