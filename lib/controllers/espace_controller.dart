import 'dart:convert';
import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/espace_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EspaceController extends GetxController {
  static EspaceController get instance => Get.find();
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

  // Méthode publique qui retourne une liste d’EspaceModel

  Future<List<EspaceModel>> getEspaces(String id) async {
    print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
    print("Maison Id $id");
    var response = await http.get(
      Uri.parse('$getEspace/$id'),
      headers: {"Content-Type": "application/json"},
    );
    print("aaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    print(id);
    print("$getEspace/$id");
    print(response.body);

    try {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // Ajout d'un contrôle supplémentaire sur le format de la réponse
        if (jsonResponse['status'] == true && jsonResponse['success'] is List) {
          List<EspaceModel> espaces =
              (jsonResponse['success'] as List)
                  .map((espace) => EspaceModel.fromJson(espace))
                  .toList();
          print(
            'Espaces : $espaces',
          ); // Vérifiez si vous obtenez les bons espaces
          return espaces;
        } else {
          print('Aucune donnée disponible ou format incorrect');
          return [];
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print('Erreur : $e');
      return [];
    }
  }

  // Supprimer un espace
  Future<bool> deleteEspace(String id) async {
    try {
      var response = await http.delete(
        Uri.parse('$deleteespace/$id'),
        headers: {"Content-Type": "application/json"},
      );
      print("$deleteespace/${id}");

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

  // Mettre à jour un espace
  Future<Map<String, dynamic>> updateEspace(
    String id,
    EspaceModel espace,
  ) async {
    var response = await http.put(
      Uri.parse('$updateespace/$id'),
      headers: {"Content-Type": "application/json"},
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
