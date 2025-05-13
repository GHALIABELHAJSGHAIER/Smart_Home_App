import 'dart:async';
import 'dart:convert';
import 'package:clone_spotify_mars/config.dart';
import 'package:clone_spotify_mars/models/Maison/salon_model.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SalonController extends GetxController {
  static SalonController get instance => Get.find();

  RxList<SalonModel> salons = <SalonModel>[].obs;
  late Timer _timer;

  String espaceId = "";

  @override
  void onInit() {
    super.onInit();
    _fetchDataPeriodically();
  }

  void _fetchDataPeriodically() {
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => getSalonByIdEspace(espaceId),
    );
  }

  Future<void> getSalonByIdEspace(String id) async {
    espaceId = id;
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.102:5000/salons/getSalonByIdEspace/$id"),
        // Uri.parse("http://192.168.100.106:5000/salons/getSalonByIdEspace/$id"),
        // Uri.parse("$getSalonByIdEspace/$id"),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] != null && body['success'] is List) {
          List<SalonModel> result =
              (body['success'] as List)
                  .map((item) => SalonModel.fromJson(item))
                  .toList();
          salons.assignAll(result);
        }
      } else {
        print("Erreur: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<void> updateRelayStatus({
    required String id,
    required bool relayOpenWindow,
    required bool relayCloseWindow,
    required bool relayClim,
  }) async {
    try {
      final response = await http.put(
        //Uri.parse("http://192.168.100.106:5000/salons/updateRelayByIdSalon/$id"),
        Uri.parse("$updateRelayByIdSalon/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'relayOpenWindow': relayOpenWindow,
          'relayCloseWindow': relayCloseWindow,
          'relayClim': relayClim,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          final updated = salons.firstWhere((s) => s.id == id);
          updated.relayOpenWindow = relayOpenWindow;
          updated.relayCloseWindow = relayCloseWindow;
          updated.relayClim = relayClim;
          salons.refresh();
        } else {
          print("Échec mise à jour : ${body['message']}");
        }
      } else {
        print("Erreur serveur : ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
