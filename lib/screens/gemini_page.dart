import 'package:clone_spotify_mars/controllers/gemini_controller.dart';
import 'package:flutter/material.dart';

class GeminiPage extends StatefulWidget {
  @override
  _GeminiPageState createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final GeminiController _controller = GeminiController();
  final TextEditingController _promptController = TextEditingController();

  List<Map<String, String>> _messages = [];
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
        _messages.add({"role": "assistant", "text": 'Erreur : \$e'});
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildMessageBubble(String role, String text) {
    final isUser = role == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color:
              isUser ? Color(0xFF4A90E2) : Color.fromARGB(255, 193, 190, 190),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          "\uD83D\uDCAC Gemini Chat",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: _messages.length + (_loading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_loading && index == _messages.length) {
                  return _buildMessageBubble("assistant", "...");
                }
                final message = _messages[index];
                return _buildMessageBubble(message["role"]!, message["text"]!);
              },
            ),
          ),
          Divider(height: 1),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: _promptController,
                      decoration: InputDecoration(
                        hintText: "\u00c9cris ton message...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _generate(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _loading ? null : _generate,
                  child: CircleAvatar(
                    backgroundColor:
                        _loading ? Colors.grey : Theme.of(context).primaryColor,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
