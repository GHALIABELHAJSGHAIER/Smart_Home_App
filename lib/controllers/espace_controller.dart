import 'dart:convert';
import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/espace_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EspaceController extends GetxController {
  // Ajouter un espace pour une maison
  Future<Map<String, dynamic>> addEspaceForMaison(String maisonId, String nom) async {
    final response = await http.post(
      Uri.parse(addEspace),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'maisonId': maisonId, 'nom': nom}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      return {'success': true, 'data': data['success']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Erreur inconnue'};
    }
  }

  // Méthode publique pour créer un espace à partir d’un EspaceModel
  Future<Map<String, dynamic>> createEspace(EspaceModel espace) async {
    return await addEspaceForMaison(espace.maisonId, espace.nom);
  }

  // Obtenir tous les espaces d'une maison
  Future<Map<String, dynamic>> getAllEspacesByMaisonId(String maisonId) async {
    final response = await http.get(Uri.parse('$getEspace/$maisonId'));

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      return {'success': true, 'data': data['success']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Erreur inconnue'};
    }
  }

  // Méthode publique qui retourne une liste d’EspaceModel
  Future<List<EspaceModel>> getEspaces(String maisonId) async {
    final response = await getAllEspacesByMaisonId(maisonId);
    if (response['success']) {
      List<dynamic> data = response['data'];
      return data.map((e) => EspaceModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  // Supprimer un espace
  Future<Map<String, dynamic>> deleteEspace(String id) async {
    final response = await http.delete(Uri.parse('$deleteEspace/$id'));

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      return {'success': true, 'message': data['success']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Erreur inconnue'};
    }
  }

  // Mettre à jour un espace
  Future<Map<String, dynamic>> updateEspace(String id, String nom) async {
    final response = await http.put(
      Uri.parse('$updateEspace/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nom': nom}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      return {'success': true, 'data': data['success']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Erreur inconnue'};
    }
  }
}
