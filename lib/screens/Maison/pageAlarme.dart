// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:clone_spotify_mars/controllers/Maison/alarme_controller.dart';

// class AlarmePage extends StatelessWidget {
//   final String maisonId;

//   const AlarmePage({super.key, required this.maisonId});

//   @override
//   Widget build(BuildContext context) {
//     final AlarmeController controller = Get.put(AlarmeController());

//     // Charger les données une seule fois au début
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (controller.alarmes.isEmpty) {
//         controller.getAlarmeByIdMaison(maisonId);
//       }
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Alarmes"),
//         backgroundColor: Colors.redAccent.shade700,
//         elevation: 2,
//       ),
//       body: Obx(() {
//         if (controller.alarmes.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.notifications_off,
//                   size: 80,
//                   color: Colors.grey.shade400,
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   "Aucune alarme disponible.",
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//               ],
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: () async {
//             await controller.getAlarmeByIdMaison(maisonId);
//           },
//           child: ListView.separated(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             itemCount: controller.alarmes.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 12),
//             itemBuilder: (context, index) {
//               final alarme = controller.alarmes[index];
//               return Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 shadowColor: Colors.redAccent.withOpacity(0.2),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 16,
//                     horizontal: 20,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.alarm, color: Colors.redAccent.shade700),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               "Alarme ID : ${alarme.id}",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                           Switch(
//                             activeColor: Colors.redAccent.shade700,
//                             value: alarme.etat,
//                             onChanged: (bool value) {
//                               controller.updateEtatAlarmeByIdAlarme(
//                                 alarme.id,
//                                 value,
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.motion_photos_on,
//                             color: Colors.orange.shade700,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             "Mouvement 1 : ",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey.shade800,
//                             ),
//                           ),
//                           Text(
//                             alarme.mvm1 ? "Détecté" : "Aucun",
//                             style: TextStyle(
//                               color:
//                                   alarme.mvm1
//                                       ? Colors.green
//                                       : Colors.grey.shade600,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.motion_photos_on_outlined,
//                             color: Colors.orange.shade700,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             "Mouvement 2 : ",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.grey.shade800,
//                             ),
//                           ),
//                           Text(
//                             alarme.mvm2 ? "Détecté" : "Aucun",
//                             style: TextStyle(
//                               color:
//                                   alarme.mvm2
//                                       ? Colors.green
//                                       : Colors.grey.shade600,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Icon(
//                             alarme.alarmeBuzzzer
//                                 ? Icons.check_circle
//                                 : Icons.cancel,
//                             color:
//                                 alarme.alarmeBuzzzer
//                                     ? Colors.green
//                                     : Colors.redAccent,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             alarme.alarmeBuzzzer
//                                 ? "Alarme activée"
//                                 : "Alarme désactivée",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color:
//                                   alarme.alarmeBuzzzer
//                                       ? Colors.green
//                                       : Colors.redAccent,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
// }

/////////222222222
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clone_spotify_mars/controllers/Maison/alarme_controller.dart';

class AlarmePage extends StatelessWidget {
  final String maisonId;

  const AlarmePage({super.key, required this.maisonId});

  @override
  Widget build(BuildContext context) {
    final AlarmeController controller = Get.put(AlarmeController());

    // Charger les données une seule fois au début
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.alarmes.isEmpty) {
        controller.getAlarmeByIdMaison(maisonId);
      }
    });

    void _showNotifBottomSheet(BuildContext context, alarme) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  "Détails de l'alarme",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.redAccent.shade700,
                  ),
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Get.back(); // Fermer le bottom sheet
                  },
                  child: const Center(child: Text("Fermer")),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarmes"),
        backgroundColor: Colors.redAccent.shade700,
        elevation: 2,
      ),
      body: Obx(() {
        if (controller.alarmes.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_off,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Aucune alarme disponible.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.getAlarmeByIdMaison(maisonId);
          },
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: controller.alarmes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final alarme = controller.alarmes[index];
              return GestureDetector(
                onTap: () => _showNotifBottomSheet(context, alarme),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.redAccent.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.alarm, color: Colors.redAccent.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Alarme ID : ${alarme.id}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Switch(
                              activeColor: Colors.redAccent.shade700,
                              value: alarme.etat,
                              onChanged: (bool value) {
                                controller.updateEtatAlarmeByIdAlarme(
                                  alarme.id,
                                  value,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.motion_photos_on,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Mouvement 1 : ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Text(
                              alarme.mvm1 ? "Détecté" : "Aucun",
                              style: TextStyle(
                                color:
                                    alarme.mvm1
                                        ? Colors.green
                                        : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.motion_photos_on_outlined,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Mouvement 2 : ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            Text(
                              alarme.mvm2 ? "Détecté" : "Aucun",
                              style: TextStyle(
                                color:
                                    alarme.mvm2
                                        ? Colors.green
                                        : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              alarme.alarmeBuzzzer
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color:
                                  alarme.alarmeBuzzzer
                                      ? Colors.green
                                      : Colors.redAccent,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              alarme.alarmeBuzzzer
                                  ? "Alarme activée"
                                  : "Alarme désactivée",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    alarme.alarmeBuzzzer
                                        ? Colors.green
                                        : Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
