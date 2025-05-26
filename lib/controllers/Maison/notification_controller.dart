import 'dart:async';
import 'dart:convert';
import 'package:clone_spotify_mars/models/Maison/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
 
class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  late Timer _timer;

  String alarmeId = "";

  @override
  void onInit() {
    super.onInit();
    _fetchNotificationsPeriodically();
  }

  void _fetchNotificationsPeriodically() {
    _timer = Timer.periodic(
      Duration(seconds: 10),
      (_) => getNotificationsByAlarmeId(alarmeId),
    );
  }

  Future<void> getNotificationsByAlarmeId(String alarmeId) async {
    if (alarmeId.isEmpty) {
      debugPrint("alarmeId vide, impossible de récupérer les notifications.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("http://192.168.100.106:5000/notifications/getNotificationsByAlarmeId/$alarmeId"),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true && body['data'] is List) {
          List<NotificationModel> result =
              (body['data'] as List)
                  .map((item) => NotificationModel.fromJson(item))
                  .toList();

          notifications.assignAll(result);
        } else {
          debugPrint("Aucune notification trouvée pour cette alarme");
          notifications.clear();
        }
      } else {
        debugPrint("Erreur HTTP: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Erreur getNotificationsByAlarmeId: $e");
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
