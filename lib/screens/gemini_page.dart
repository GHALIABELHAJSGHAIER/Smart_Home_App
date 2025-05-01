import 'package:clone_spotify_mars/controllers/gemini_controller.dart';
import 'package:flutter/material.dart';

class GeminiPage extends StatefulWidget {
  @override
  _GeminiPageState createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final GeminiController _controller = GeminiController();
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> _messages =
      []; // [{ "role": "user"/"assistant", "text": "..." }]
  bool _loading = false;

  void _generate() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": prompt});
      _loading = true;
      _promptController.clear();
    });

    try {
      final response = await _controller.generateContent(prompt);
      setState(() {
        _messages.add({"role": "assistant", "text": response.response});
      });
    } catch (e) {
      setState(() {
        _messages.add({"role": "assistant", "text": 'Erreur : $e'});
      });
    } finally {
      setState(() => _loading = false);
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Widget _buildMessageBubble(String role, String text) {
    final isUser = role == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Gemini")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    _messages.map((message) {
                      return _buildMessageBubble(
                        message["role"]!,
                        message["text"]!,
                      );
                    }).toList(),
              ),
            ),
          ),
          if (_loading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration: InputDecoration.collapsed(
                      hintText: "Écris ton message...",
                    ),
                    onSubmitted: (_) => _generate(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed: _loading ? null : _generate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
