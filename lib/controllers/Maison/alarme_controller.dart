import 'dart:async';
import 'dart:convert';
import 'package:clone_spotify_mars/models/Maison/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:clone_spotify_mars/models/Maison/alarme_model.dart';

class AlarmeController extends GetxController {
  static AlarmeController get instance => Get.find();

  RxList<AlarmeModel> alarmes = <AlarmeModel>[].obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  late Timer _timer;
  String maisonId = "";

  @override
  void onInit() {
    super.onInit();
    _fetchDataPeriodically();
  }

  void _fetchDataPeriodically() {
    _timer = Timer.periodic(
      Duration(seconds: 10),
      (_) => getAlarmeByIdMaison(maisonId),
    );
  }

  Future<void> getAlarmeByIdMaison(String id) async {
    maisonId = id;
    print("getAlarmeByIdMaison() appelé pour la maison : $maisonId");

    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.102:5000/alarmes/getAlarmeByIdMaison/$id"),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] != null && body['success'] is List) {
          List<dynamic> data = body['success'];
          if (data.isNotEmpty) {
            List<AlarmeModel> result =
                data.map((item) {
                  final alarme = AlarmeModel.fromJson(item);

                  // Mise à jour automatique de alarmeBuzzzer selon mvm1 ou mvm2
                  alarme.alarmeBuzzzer = alarme.mvm1 || alarme.mvm2;

                  return alarme;
                }).toList();

            alarmes.assignAll(result);
          } else {
            debugPrint("Aucune alarme trouvée.");
          }
        } else {
          debugPrint("Clé 'success' mal formée ou vide.");
        }
      } else {
        debugPrint("Erreur serveur : ${response.body}");
      }
    } catch (e) {
      debugPrint("Exception dans getAlarmeByIdMaison : $e");
    }
  }
  //getAlarmeByIdMaison  man8ir 5idmit if mvm1 ==true or mvm2 ==true alaramebuzzer ==true
  // Future<void> getAlarmeByIdMaison(String id) async {
  //   maisonId = id;
  //   print("getAlarmeByIdMaison() appelé pour la maison : $maisonId");

  //   try {
  //     final response = await http.get(
  //       Uri.parse(
  //         "http://192.168.1.102:5000/alarmes/getAlarmeByIdMaison/$id",
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       final body = jsonDecode(response.body);
  //       if (body['success'] != null && body['success'] is List) {
  //         List<dynamic> data = body['success'];
  //         if (data.isNotEmpty) {
  //           List<AlarmeModel> result =
  //               data.map((item) => AlarmeModel.fromJson(item)).toList();
  //           alarmes.assignAll(result);
  //         } else {
  //           debugPrint("Aucune alarme trouvée.");
  //         }
  //       } else {
  //         debugPrint("Clé 'success' mal formée ou vide.");
  //       }
  //     } else {
  //       debugPrint("Erreur serveur : ${response.body}");
  //     }
  //   } catch (e) {
  //     debugPrint("Exception dans getAlarmeByIdMaison : $e");
  //   }
  // }
  Future<void> updateEtatAlarmeByIdAlarme(String id, bool etat) async {
    try {
      final response = await http.put(
        Uri.parse(
          "http://192.168.1.102:5000/alarmes/updateEtatAlarmeByIdAlarme/$id",
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'etat': etat}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          final updatedList =
              alarmes.map((alarme) {
                if (alarme.id == id) {
                  bool buzzzer =
                      alarme.mvm1 || alarme.mvm2 ? true : alarme.alarmeBuzzzer;

                  // Si buzzzer est true, créer une notification
                  if (buzzzer) {
                    final notif = NotificationModel(
                      id: UniqueKey().toString(),
                      alarmeId: alarme.id,
                      notifMsg: "Alarme activée sur l'alarme ${alarme.id}",
                      date: DateTime.now(),
                    );
                    notifications.add(notif);
                    print("Notification créée : ${notif.notifMsg}");
                    // Ici, tu peux aussi appeler une API pour sauvegarder la notif côté serveur
                  }

                  return AlarmeModel(
                    id: alarme.id,
                    etat: etat,
                    mvm1: alarme.mvm1,
                    mvm2: alarme.mvm2,
                    alarmeBuzzzer: buzzzer,
                    maisonId: alarme.maisonId,
                  );
                }
                return alarme;
              }).toList();

          alarmes.assignAll(updatedList);
        }
      }
    } catch (e) {
      print("Erreur updateEtatAlarmeByIdAlarme : $e");
    }
  }
  //updateEtatAlarmeByIdAlarme b 5idmit if mvm1 ==true or mvm2 ==true alaramebuzzer ==true
  //                            mais man8ir 5idmit notification
  // Future<void> updateEtatAlarmeByIdAlarme(String id, bool etat) async {
  //   print("updateEtatAlarmeByIdAlarme() pour $id : $etat");

  //   try {
  //     final response = await http.put(
  //       Uri.parse(
  //         "http://192.168.1.102:5000/alarmes/updateEtatAlarmeByIdAlarme/$id",
  //       ),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'etat': etat}),
  //     );

  //     if (response.statusCode == 200) {
  //       final body = jsonDecode(response.body);
  //       if (body['status'] == true) {
  //         // Mettre à jour la liste localement en tenant compte des conditions sur mvm1 et mvm2
  //         final updatedList =
  //             alarmes.map((alarme) {
  //               if (alarme.id == id) {
  //                 // Si mvm1 ou mvm2 est true, forcer alarmeBuzzzer à true
  //                 bool buzzzer =
  //                     alarme.mvm1 || alarme.mvm2 ? true : alarme.alarmeBuzzzer;

  //                 return AlarmeModel(
  //                   id: alarme.id,
  //                   etat: etat,
  //                   mvm1: alarme.mvm1,
  //                   mvm2: alarme.mvm2,
  //                   alarmeBuzzzer: buzzzer,
  //                   maisonId: alarme.maisonId,
  //                 );
  //               }
  //               return alarme;
  //             }).toList();

  //         alarmes.assignAll(updatedList);
  //         debugPrint("Alarme mise à jour avec succès.");
  //       } else {
  //         debugPrint("Erreur de mise à jour : ${body['message']}");
  //       }
  //     } else {
  //       debugPrint("Erreur HTTP : ${response.body}");
  //     }
  //   } catch (e) {
  //     debugPrint("Exception dans updateEtatAlarmeByIdAlarme : $e");
  //   }
  // }
  //updateEtatAlarmeByIdAlarme  man8ir 5idmit if mvm1 ==true or mvm2 ==true alaramebuzzer ==true
  // Future<void> updateEtatAlarmeByIdAlarme(String id, bool etat) async {
  //   print("updateEtatAlarmeByIdAlarme() pour $id : $etat");

  //   try {
  //     final response = await http.put(
  //       Uri.parse(
  //         "http://192.168.1.102:5000/alarmes/updateEtatAlarmeByIdAlarme/$id",
  //       ),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'etat': etat}),
  //     );

  //     if (response.statusCode == 200) {
  //       final body = jsonDecode(response.body);
  //       if (body['status'] == true) {
  //         final updatedList =
  //             alarmes.map((alarme) {
  //               if (alarme.id == id) {
  //                 return AlarmeModel(
  //                   id: alarme.id,
  //                   etat: etat,
  //                   mvm1: alarme.mvm1,
  //                   mvm2: alarme.mvm2,
  //                   alarmeBuzzzer: alarme.alarmeBuzzzer,
  //                   maisonId: alarme.maisonId,
  //                 );
  //               }
  //               return alarme;
  //             }).toList();

  //         alarmes.assignAll(updatedList);
  //         debugPrint("Alarme mise à jour avec succès.");
  //       } else {
  //         debugPrint("Erreur de mise à jour : ${body['message']}");
  //       }
  //     } else {
  //       debugPrint("Erreur HTTP : ${response.body}");
  //     }
  //   } catch (e) {
  //     debugPrint("Exception dans updateEtatAlarmeByIdAlarme : $e");
  //   }
  // }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
