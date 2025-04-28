import 'dart:convert';
import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/gemini_model.dart';
import 'package:http/http.dart' as http;

class GeminiController {
  //final String baseUrl = 'http://ton_serveur_ip_ou_domaine/gemini';

  Future<GeminiResponse> generateContent(String prompt) async {
    //final url = Uri.parse('$baseUrl/generate');
    final response = await http.post(
      //url,
      Uri.parse(gemini),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );

    if (response.statusCode == 200) {
      return GeminiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erreur API Gemini: ${response.body}');
    }
  }
}
