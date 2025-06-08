import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/Maison/chambre_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChambreController extends GetxController {
  static ChambreController get instance => Get.find();

  RxList<ChambreModel> chambres = <ChambreModel>[].obs;
  late Timer _timer;

  String espaceId = "";

  @override
  void onInit() {
    super.onInit();
    _fetchDataPeriodically();
  }

  void _fetchDataPeriodically() {
    _timer = Timer.periodic(
      Duration(seconds: 10),
      (_) => getChambreByIdEspace(espaceId),
    );
  }

  Future<void> getChambreByIdEspace(String id) async {
    espaceId = id;
    print("aaaaaaaa");
    print(espaceId);
    try {
      //final response = await http.get(Uri.parse("$getChambreByIdEspace/$id"));
      final response = await http.get(
        Uri.parse(
          //"http://192.168.1.102:5000/chambres/getChambreByIdEspace/$id",
          "http://192.168.1.102:5000/chambres/getChambreByIdEspace/$id",
        ),
        // Uri.parse("$getSalonByIdEspace/$id"),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("Réponse du serveur : $body");
        if (body['success'] != null && body['success'] is List) {
          List<dynamic> data = body['success'];
          if (data.isNotEmpty && data.isNotEmpty) {
            List<ChambreModel> result =
                data.map((item) {
                  return ChambreModel.fromJson(item);
                }).toList();
            chambres.assignAll(result);
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
  Future<void> updateRelayStatus(
    String id,
    bool relayOpenWindow,
    bool relayCloseWindow,
    bool relayClimChambre,
    bool relayLamp,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$updateRelayByIdChambre/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'relayOpenWindow': relayOpenWindow,
          'relayCloseWindow': relayCloseWindow,
          'relayClimChambre': relayClimChambre,
          'relayLamp': relayLamp,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          // Trouver la cuisine et mettre à jour l'état relayInc localement
          final updatedChambre = chambres.firstWhere(
            (chambre) => chambre.id == id,
          );
          updatedChambre.relayOpenWindow = relayOpenWindow;
          updatedChambre.relayCloseWindow = relayCloseWindow;
          updatedChambre.relayClimChambre = relayClimChambre;
          updatedChambre.relayLamp = relayLamp;
          chambres.refresh();
          //debugPrint("Mise à jour réussie : ${updatedChambre.relayInc}");
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
