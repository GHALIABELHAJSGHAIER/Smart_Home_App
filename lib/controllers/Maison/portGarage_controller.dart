import 'dart:async';
import 'package:clone_spotify_mars/models/Maison/historiqueGarage_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
//import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/Maison/portGarage_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PortgarageController extends GetxController {
  static PortgarageController get instance => Get.find();

  RxList<PortGarageModel> garages = <PortGarageModel>[].obs;
  RxList<HistoriqueGarageModel> historique = <HistoriqueGarageModel>[].obs;

  late Timer _timer;

  String clientId = "";

  @override
  void onInit() {
    super.onInit();
    _fetchDataPeriodically();
  }

  void _fetchDataPeriodically() {
    _timer = Timer.periodic(
      Duration(seconds: 10),
      (_) => getPortGarageByIdClient(clientId),
    );
  }

  Future<void> getPortGarageByIdClient(String id) async {
    clientId = id;
    print("getPortGarageByIdClient WWWWWWWWW");
    print(clientId);
    try {
      //final response = await http.get(Uri.parse("$getPortGarageByIdClient/$id"));
      final response = await http.get(
        //192.168.100.106 WIFI OOREDOO
        //192.168.1.102 WIFI NET
        Uri.parse(
          //"http://192.168.1.102:5000/garages/getPortGarageByIdClient/$id",
          "http://192.168.100.106:5000/garages/getPortGarageByIdClient/$id",
        ),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("Réponse du serveur : $body");
        if (body['success'] != null && body['success'] is List) {
          List<dynamic> data = body['success'];
          if (data.isNotEmpty && data.isNotEmpty) {
            List<PortGarageModel> result =
                data.map((item) {
                  return PortGarageModel.fromJson(item);
                }).toList();
            garages.assignAll(result);
          } else {
            debugPrint("Aucune donnée dans 'success'.");
          }
        } else {
          debugPrint("La clé 'success' est vide ou mal formée.");
        }
      } else {
        debugPrint("Réponse historique:: ${response.body}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
    }
  }

  // Fonction pour mettre à jour portGarage
  Future<void> updatePortGarageByIdGarage(String id, bool portGarage) async {
    print("updatePortGarageByIdGarage");
    try {
      final response = await http.put(
        Uri.parse(
         // "http://192.168.1.102:5000/garages/updatePortGarageByIdGarage/$id",
          "http://192.168.100.106:5000/garages/updatePortGarageByIdGarage/$id",
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'portGarage': portGarage}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          // Créer une nouvelle liste avec l'élément mis à jour
          final updatedList =
              garages.map((garage) {
                if (garage.id == id) {
                  return PortGarageModel(
                    id: garage.id,
                    portGarage: portGarage, // Nouvelle valeur
                    clientId: garage.clientId,
                  );
                }
                return garage;
              }).toList();

          // Mettre à jour la liste observable
          garages.assignAll(updatedList);

          debugPrint("Mise à jour réussie : $portGarage");
        } else {
          debugPrint("Erreur lors de la mise à jour : ${body['message']}");
        }
      } else {
        debugPrint("Erreur: ${response.body}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
    }
  }

  Future<void> getHistoriqueByGarageId(String garageId) async {
    print("getHistoriqueByGarageId HHHHHHHHHHHHHH");
    try {
      final response = await http.get(
        Uri.parse(
          //"http://192.168.1.102:5000/garages/getHistoriqueByGarageId/$garageId",
          "http://192.168.100.106:5000/garages/getHistoriqueByGarageId/$garageId",
        ),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true && body['historique'] is List) {
          List<HistoriqueGarageModel> result =
              (body['historique'] as List)
                  .map((item) => HistoriqueGarageModel.fromJson(item))
                  .toList();

          historique.assignAll(result);
        }
      }
    } catch (e) {
      debugPrint("Erreur getHistoriqueByGarageId: $e");
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
