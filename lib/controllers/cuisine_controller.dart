import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/cuisine_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CuisineController extends GetxController {
  static CuisineController get instance => Get.find();

  RxList<CuisineModel> cuisines = <CuisineModel>[].obs;
  late Timer _timer;

  String espaceId = "";

  @override
  void onInit() {
    super.onInit();
    _fetchDataPeriodically();
  }

  void _fetchDataPeriodically() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (_) => getCuisineByIdEspace(espaceId),
    );
  }

  Future<void> getCuisineByIdEspace(String id) async {
    espaceId = id;
    print("aaaaaaaa");
    print(espaceId);
    try {
      final response = await http.get(Uri.parse("$getCuisineByIdespace/$id"));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("Réponse du serveur : $body");
        if (body['success'] != null && body['success'] is List) {
          List<dynamic> data = body['success'];
          if (data != null && data.isNotEmpty) {
            List<CuisineModel> result =
                data.map((item) {
                  return CuisineModel.fromJson(item);
                }).toList();
            cuisines.assignAll(result);
          } else {
            debugPrint("Aucune donnée dans 'success'.");
          }
        } else {
          debugPrint("La clé 'success' est vide ou mal formée.");
        }
      } else {
        debugPrint("Erreur: ${response.body}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
    }
  }

  // Fonction pour mettre à jour relayInc
  Future<void> updateRelayStatus(String id, bool relayInc) async {
    try {
      final response = await http.put(
        Uri.parse("$updateRelayByIdCuisine/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'relayInc': relayInc}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          // Trouver la cuisine et mettre à jour l'état relayInc localement
          final updatedCuisine = cuisines.firstWhere(
            (cuisine) => cuisine.id == id,
          );
          updatedCuisine.relayInc = relayInc;
          cuisines.refresh();
          debugPrint("Mise à jour réussie : ${updatedCuisine.relayInc}");
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

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
