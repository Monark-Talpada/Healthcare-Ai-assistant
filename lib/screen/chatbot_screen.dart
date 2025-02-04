import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'isBot': true,
      'message': 'Hello! I\'m your medical assistant. How can I help you today?',
      'options': ['Emergency', 'General Health', 'First Aid Advice'],
    }
  ];
  final TextEditingController _controller = TextEditingController();

  void _handleOption(String option) {
    setState(() {
      _messages.add({
        'isBot': false,
        'message': option,
      });

      switch (option) {
        case 'Emergency':
          _messages.add({
            'isBot': true,
            'message': 'What type of emergency are you experiencing?',
            'options': ['Chest Pain', 'Difficulty Breathing', 'Severe Injury'],
          });
          break;
        case 'General Health':
          _messages.add({
            'isBot': true,
            'message': 'What would you like to know about?',
            'options': ['Preventive Care', 'Nutrition', 'Exercise'],
          });
          break;
        default:
          _messages.add({
            'isBot': true,
            'message': 'How can I assist you with $option?',
            'options': ['More Info', 'Talk to Doctor', 'View Guidelines'],
          });
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'isBot': false,
          'message': _controller.text,
        });
        _messages.add({
          'isBot': true,
          'message': 'Thank you for sharing. How can I help you with this?',
          'options': ['Get Advice', 'Emergency Help', 'Talk to Doctor'],
        });
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Assistant'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment:
            message['isBot'] ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message['isBot']
                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                  : const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message['message'],
              style: TextStyle(
                color: message['isBot'] ? Colors.black : Colors.white,
              ),
            ),
          ),
          if (message['options'] != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: (message['options'] as List).map((option) {
                return ActionChip(
                  label: Text(option),
                  onPressed: () => _handleOption(option),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: const Color(0xFF4CAF50),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}