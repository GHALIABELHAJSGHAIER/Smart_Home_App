import 'dart:async';
import 'dart:convert';
import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/cuisine_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CuisineController extends GetxController {
  static CuisineController get instance => Get.find();

  var cuisineModel = Rxn<CuisineModel>(); // Modèle cuisine observable
  late Timer _timer;
  late String cuisineId;
  // Liste observable des cuisines
  var cuisines = <CuisineModel>[].obs;

  // Constructor to receive the espaceId
  CuisineController({required String espaceId}) {
    this.cuisineId = espaceId; // Initialize cuisineId here
  }

  @override
  void onInit() {
    super.onInit();
    // Appel initial pour récupérer les données using the initialized cuisineId
    getCuisineByIdEspace(cuisineId);

    // Démarrer un timer to periodically fetch data
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => getCuisineByIdEspace(cuisineId),
    );
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
  }

  // Récupérer une cuisine par son ID
  Future<void> getCuisineById(String id) async {
    print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
    print("cUISINE Id $id");
    try {
      final response = await http.get(Uri.parse("$getCuisineById/$id"));
      // print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        cuisineModel.value = CuisineModel.fromJson(data['success']);
      } else {
        print("Erreur getCuisineById: ${response.body}");
      }
    } catch (e) {
      print("Exception dans getCuisineById: $e");
    }
  }

  // Mettre à jour l'état du relais
  // Future<void> updateRelay() async {
  //   try {
  //     if (cuisineModel.value != null) {
  //       bool newRelayState = !cuisineModel.value!.relayInc;
  //       final response = await http.put(
  //         Uri.parse("$updateRelayById/${cuisineModel.value!.id}"),
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode({"relayInc": newRelayState}),
  //       );

  //       if (response.statusCode == 200) {
  //         print("Relay mis à jour !");
  //         // Rafraîchir les données
  //         getCuisineById(cuisineModel.value!.id);
  //       } else {
  //         print("Erreur updateRelay: ${response.body}");
  //       }
  //     }
  //   } catch (e) {
  //     print("Exception dans updateRelay: $e");
  //   }
  // }

  // Récupérer toutes les cuisines liées à un espace
  Future<void> getCuisineByIdEspace(String espaceId) async {
    final uri = Uri.parse("$getCuisineByIdespace/$espaceId");
    //    final uri = Uri.parse(
    //   'http://192.168.100.106:5000/cuisines/getCuisineByIdEspace/$espaceId',
    // );
    print("URI appelée : $uri");

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> cuisinesJson = data['success'];
        cuisines.value =
            cuisinesJson.map((json) => CuisineModel.fromJson(json)).toList();
      } else {
        print("Erreur getCuisineByIdEspace: ${response.body}");
      }
    } catch (e) {
      print("Exception dans getCuisineByIdEspace: $e");
    }
  }

  // Mettre à jour un cuisine

  // Future<Map<String, dynamic>> updateRelay(
  //   String id,
  //   CuisineModel cuisine,
  // ) async {
  //   var response = await http.put(
  //     Uri.parse('$updateRelayById/$id'),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode(cuisine.toJson()),
  //   );

  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 && data['status'] == true) {
  //     return {'success': true, 'data': data['success']};
  //   } else {
  //     return {
  //       'success': false,
  //       'message': data['message'] ?? 'Erreur inconnue',
  //     };
  //   }
  // }
  // Future<void> sendToggleState(String id,bool relayInc) async {
  //     var response = await http.put(
  //       Uri.parse("$updateRelayById/$id"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "relayInc": relayInc, // Met à jour le relais avec la valeur true ou false
  //       }),
  //     );

  //     try {
  //       var jsonResponse = jsonDecode(response.body);

  //       if (jsonResponse['status']) {
  //         print("Relay status updated: ${jsonResponse['success']['relay']}");
  //         // Mise à jour de l'état du relais localement
  //         CuisineModel.value?.relayInc = jsonResponse['success']['relay'];
  //       } else {
  //         print("Erreur de mise à jour du relais : ${jsonResponse['message']}");
  //       }
  //     } catch (e) {
  //       print("Erreur lors de la mise à jour de l'état du relais: $e");
  //     }
  //   }

  // Ajouter un cuisine pour une cuisine
  // Future<Map<String, dynamic>> createCuisineForEspace(CuisineModel cuisine) async {
  //   final response = await http.post(
  //     Uri.parse(addCuisine),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(cuisine.toJson()),
  //   );

  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 && data['status'] == true) {
  //     return {'success': true, 'data': data['success']};
  //   } else {
  //     return {
  //       'success': false,
  //       'message': data['message'] ?? 'Erreur inconnue',
  //     };
  //   }
  // }

  // Méthode publique qui retourne une liste d’CuisineModel

  // Future<List<CuisineModel>> getCuisines(String id) async {
  //   print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
  //   print("Espace Id $id");
  //   var response = await http.get(
  //     Uri.parse('$getEspace/$id'),
  //     headers: {"Content-Type": "application/json"},
  //   );
  //   print("aaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
  //   print(id);
  //   print("$getEspace/$id");
  //   print(response.body);

  //   try {
  //     if (response.statusCode == 200) {
  //       var jsonResponse = jsonDecode(response.body);

  //       // Ajout d'un contrôle supplémentaire sur le format de la réponse
  //       if (jsonResponse['status'] == true && jsonResponse['success'] is List) {
  //         List<CuisineModel> cuisines =
  //             (jsonResponse['success'] as List)
  //                 .map((cuisine) => CuisineModel.fromJson(cuisine))
  //                 .toList();
  //         print(
  //           'Cuisines : $cuisines',
  //         ); // Vérifiez si vous obtenez les bons cuisines
  //         return cuisines;
  //       } else {
  //         print('Aucune donnée disponible ou format incorrect');
  //         return [];
  //       }
  //     } else {
  //       throw Exception("Failed to load data: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print('Erreur : $e');
  //     return [];
  //   }
  // }

  // Supprimer un espace

  // Future<bool> deleteCuisine(String id) async {
  //   try {
  //     var response = await http.delete(
  //       Uri.parse('$deleteespace/$id'),
  //       headers: {"Content-Type": "application/json"},
  //     );
  //     print("$deleteespace/${id}");

  //     if (response.statusCode == 200) {
  //       var jsonResponse = jsonDecode(response.body);
  //       return jsonResponse['status'];
  //     } else {
  //       throw Exception("Failed to delete Espace: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // Mettre à jour un cuisine

  // Future<Map<String, dynamic>> updateCuisine(
  //   String id,
  //   CuisineModel cuisine,
  // ) async {
  //   var response = await http.put(
  //     Uri.parse('$updateespace/$id'),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode(cuisine.toJson()),
  //   );

  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200 && data['status'] == true) {
  //     return {'success': true, 'data': data['success']};
  //   } else {
  //     return {
  //       'success': false,
  //       'message': data['message'] ?? 'Erreur inconnue',
  //     };
  //   }
  // }
}
