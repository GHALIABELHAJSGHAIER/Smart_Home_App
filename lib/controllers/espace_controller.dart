import 'dart:convert';
import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/espace_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EspaceController extends GetxController {
  // Ajouter un espace pour une espace
  Future<Map<String, dynamic>> createEspaceForMaison(EspaceModel espace) async {
    final response = await http.post(
      Uri.parse(addEspace),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(espace.toJson()),
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

  // Obtenir tous les espaces d'une maison
  /*Future<Map<String, dynamic>> getAllEspacesByMaisonId(String maisonId) async {
    final response = await http.get(Uri.parse('$getEspace/$maisonId'));

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      return {'success': true, 'data': data['success']};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Erreur inconnue',
      };
    }
  }*/

  // Méthode publique qui retourne une liste d’EspaceModel

  Future<List<EspaceModel>> getEspaces(String id) async {
    print(id);
    var response = await http.get(
      Uri.parse('$getEspace/$id'),
      
      headers: {"Content-Type": "application/json"},
    );

    print("$getEspace/${id}");

    try {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == true) {
          return (jsonResponse['success'] as List)
              .map((espace) => EspaceModel.fromJson(espace))
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

  // Supprimer un espace
  /*Future<Map<String, dynamic>> deleteEspace(String id) async {
    final response = await http.delete(Uri.parse('$deleteEspace/$id'));

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      return {'success': true, 'message': data['success']};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Erreur inconnue',
      };
    }
  }*/
  Future<bool> deleteEspace(String id) async {
    try {
      var response = await http.delete(
        Uri.parse('$deleteEspace/$id'),
        headers: {"Content-Type": "application/json"},
      );
      print("$deleteEspace/${id}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse['status'];
      } else {
        throw Exception("Failed to delete espace: ${response.statusCode}");
      }
    } catch (e) {
      return false;
    }
  }

  // Mettre à jour un espace
  Future<Map<String, dynamic>> updateEspace(
    String id,
    EspaceModel espace,
  ) async {
    final response = await http.put(
      Uri.parse('$updateEspace/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(espace.toJson()),
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
