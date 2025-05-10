import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/Maison/wc_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WcController extends GetxController {
  static WcController get instance => Get.find();

  RxList<WcModel> wcs = <WcModel>[].obs;
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
      (_) => getWcByIdEspace(espaceId),
    );
  }

  Future<void> getWcByIdEspace(String id) async {
    espaceId = id;
    print("WW");
    print(espaceId);
    try {
      final response = await http.get(
        //192.168.100.106 WIFI OOREDOO
        //192.168.1.102 WIFI NET
        Uri.parse("http://192.168.100.106:5000/wcs/getWcByIdEspace/$id"),
      );
      // final response = await http.get(
      //   Uri.parse(
      //     "$getWccByIdEspace/$id",
      //   ), // Utilisation propre de la constante
      // );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("Réponse du serveur : $body");
        if (body['success'] != null && body['success'] is List) {
          List<dynamic> data = body['success'];
          if (data != null && data.isNotEmpty) {
            List<WcModel> result =
                data.map((item) {
                  return WcModel.fromJson(item);
                }).toList();
            wcs.assignAll(result);
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

  // Fonction pour mettre à jour
  Future<void> updateRelayStatus(
    String id,
    bool relaySolarHeat,
    bool relayHeat,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$updateRelayByIdWc/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'relaySolarHeat': relaySolarHeat,
          'relayHeat': relayHeat,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          // Trouver la wc et mettre à jour l'état  localement
          final updatedWc = wcs.firstWhere((wc) => wc.id == id);
          updatedWc.relaySolarHeat = relaySolarHeat;
          updatedWc.relayHeat = relayHeat;
          wcs.refresh();
          debugPrint(
            "Mise à jour réussie : ${updatedWc.relaySolarHeat}, ${updatedWc.relayHeat}",
          );
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
