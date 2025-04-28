import 'package:clone_spotify_mars/controllers/gemini_controller.dart';
import 'package:flutter/material.dart';

class GeminiPage extends StatefulWidget {
  @override
  _GeminiPageState createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final GeminiController _controller = GeminiController();
  final TextEditingController _promptController = TextEditingController();

  String _result = '';
  bool _loading = false;

  void _generate() async {
    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final response = await _controller.generateContent(_promptController.text);
      setState(() {
        _result = response.response;
      });
    } catch (e) {
      setState(() {
        _result = 'Erreur : $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gemini Generator")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: InputDecoration(labelText: "Prompt"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _generate,
              child: _loading ? CircularProgressIndicator() : Text("Générer"),
            ),
            SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: Text(_result))),
          ],
        ),
      ),
    );
  }
}
