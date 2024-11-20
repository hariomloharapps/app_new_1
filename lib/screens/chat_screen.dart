import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_composer.dart';
import '../widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isWaitingForResponse = false;

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _isWaitingForResponse) return;

    final message = ChatMessage(
      text: text,
      isSent: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(message);
      _isWaitingForResponse = true;
      _scrollToBottom();
    });

    try {
      await ChatService.sendMessage(message);

      ChatService.getMessageStatus(message.id).listen((status) {
        setState(() {
          final index = _messages.indexWhere((m) => m.id == message.id);
          if (index != -1) {
            _messages[index] = ChatMessage(
              text: message.text,
              isSent: true,
              timestamp: message.timestamp,
              status: status,
            );
          }
        });
      });

      _simulateReceivedMessage();
    } catch (e) {
      setState(() {
        _isWaitingForResponse = false;
        // You might want to show an error message here
      });
    }
  }

  void _simulateReceivedMessage() {
    setState(() => _isTyping = true);
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text: "This is a demo response",
            isSent: false,
            timestamp: DateTime.now(),
          ),
        );
        _isWaitingForResponse = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isTyping) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: MinimalTypingIndicator(),
            ),
          );
        }
        return MessageBubble(message: _messages[index]);
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: MessageComposer(
        onSubmitted: _handleSubmitted,
        canSend: !_isWaitingForResponse, // or whatever boolean controls send ability
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2C2C2E),
          secondary: Color(0xFF48484A),
          surface: Color(0xFF1C1C1E),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modern Chat'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show more options menu
                showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF1C1C1E),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => _buildMoreOptionsSheet(),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF121212),
                const Color(0xFF1C1C1E).withOpacity(0.95),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildMessageList()),
                _buildInputArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoreOptionsSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.white),
            title: const Text('Clear Chat'),
            onTap: () {
              setState(() => _messages.clear());
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.block_outlined, color: Colors.white),
            title: const Text('Block User'),
            onTap: () {
              // Implement block user functionality
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.report_outlined, color: Colors.white),
            title: const Text('Report Issue'),
            onTap: () {
              // Implement report functionality
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}