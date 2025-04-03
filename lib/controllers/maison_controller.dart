import 'dart:convert';
import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/maison_model.dart';
import 'package:get/get.dart';
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
      return {"status": true, "success": "MAISON Registered Successfully"};
    } else {
      return {
        "status": false,
        "error": jsonResponse['message'] ?? "MAISON Failed",
      };
    }
  }



  // Get maison list: GET /maisons/getMaisonsByClientId/:clientId
  Future<List<MaisonModel>> getMaisonList(String clientId) async {
    try {
      var response = await http.get(
        Uri.parse('$getMaison/$clientId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == true) {
          return (jsonResponse['success'] as List)
              .map((maison) => MaisonModel.fromJson(maison))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      return [];
    }
  }

  // Delete maison: DELETE /maisons/deleteMaisonById/:id
  Future<bool> deleteMaison(String id) async {
    try {
      var response = await http.delete(
        Uri.parse('$deleteMaison/$id'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse['status'];
      } else {
        throw Exception("Failed to delete maison: ${response.statusCode}");
      }
    } catch (e) {
      return false;
    }
  }
}
