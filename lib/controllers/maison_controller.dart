import 'dart:convert';
import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/maison_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MaisonController extends GetxController {
  static MaisonController get instance => Get.find();

 
  Future<Map<String, dynamic>> createMaison(MaisonModel maison) async {
    final response = await http.post(
      Uri.parse(addMaison),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(maison.toJson()),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      return {'success': true, 'data': data['success']};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Erreur inconnue',
      };
    }
  }

  // Get maison list: GET /maisons/getMaisonsByClientId/:clientId
  Future<List<MaisonModel>> getMaisonList(String id) async {
    print(id);
    var response = await http.get(
      Uri.parse('$getMaison/$id'),
      headers: {"Content-Type": "application/json"},
    );
    print("$getMaison/${id}");
    //print(response);
    try {
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
        Uri.parse('$deletemaison/$id'),
        headers: {"Content-Type": "application/json"},
      );
      print("$deletemaison/${id}");

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

  // Update maison: PUT /maisons/updateMaison/:id
 
  Future<Map<String, dynamic>> updateMaison(
    String id,
    MaisonModel maison,
  ) async {
    var response = await http.put(
      Uri.parse('$updatemaison/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(maison.toJson()),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      return {'success': true, 'data': data['success']};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Erreur inconnue',
      };
    }
  }
}
