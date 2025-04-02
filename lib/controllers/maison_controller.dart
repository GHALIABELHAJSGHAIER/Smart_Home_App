import 'dart:convert';

import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/maison_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

class MaisonController extends GetxController {
  static MaisonController get instance => Get.find();

  Future<Map<String, dynamic>> createMaison(MaisonModel maison) async {
    var response = await http.post(
      Uri.parse(storeMaison),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(maison.toJson()),
    );

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == true) {
      return {"status": true, "success": "Maison Registered Successfully"};
    } else {
      return {
        "status": false,
        "error": jsonResponse['message'] ?? "Maison Registration Failed",
      };
    }
  }

  Future<List<MaisonModel>> getMaisonList(String userId) async {
    var response = await http.get(
      Uri.parse('$getMaison/$userId'),
      headers: {"Content-Type": "application/json"},
    );

    try {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        return (jsonResponse['success'] as List)
            .map((maison) => MaisonModel.fromJson(maison))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteMaison(String id) async {
    var response = await http.delete(
      Uri.parse('$deleteMaison/$id'),
      headers: {"Content-Type": "application/json"},
    );
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse['status'];
  }
}
