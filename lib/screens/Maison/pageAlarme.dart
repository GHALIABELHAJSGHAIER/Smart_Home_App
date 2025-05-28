import 'package:clone_spotify_mars/controllers/Maison/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clone_spotify_mars/controllers/Maison/alarme_controller.dart';
import 'package:intl/intl.dart';

class AlarmePage extends StatelessWidget {
  final String maisonId;

  const AlarmePage({super.key, required this.maisonId});

  @override
  Widget build(BuildContext context) {
    final AlarmeController controller = Get.put(AlarmeController());
    final NotificationController notifController = Get.put(
      NotificationController(),
    );

    // Charger les données une seule fois au début
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.alarmes.isEmpty) {
        controller.getAlarmeByIdMaison(maisonId);
      }
    });
    void _showNotifBottomSheet(BuildContext context, alarme) {
      final NotificationController notifController = Get.put(
        NotificationController(),
      );

      // Charger les notifications pour l'alarme sélectionnée
      notifController.getNotificationsByAlarmeId(alarme.id);

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Obx(() {
            final notifications =
                notifController.notifications
                  ..sort((a, b) => b.date.compareTo(a.date));

            return AlertDialog(
              title: const Text("Détails de l'alarme"),
              content: Container(
                width: double.maxFinite,
                child:
                    notifications.isEmpty
                        ? const Text("Aucune notification trouvée.")
                        : ListView.builder(
                          shrinkWrap: true,
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notif = notifications[index];
                            return ListTile(
                              leading: const Icon(
                                Icons.notifications,
                                color: Colors.blueAccent,
                              ),
                              title: Text(notif.notifMsg),
                              subtitle: Text(
                                DateFormat(
                                  'dd/MM/yyyy HH:mm',
                                ).format(notif.date),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (_) => AlertDialog(
                                          title: const Text("Confirmation"),
                                          content: const Text(
                                            "Voulez-vous vraiment supprimer cette notification ?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text("Annuler"),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: const Text("Supprimer"),
                                            ),
                                          ],
                                        ),
                                  );

                                  if (confirm == true) {
                                    final success = await notifController
                                        .deleteNotificationById(notif.id);
                                    if (success) {
                                      Get.snackbar(
                                        "Succès",
                                        "Notification supprimée",
                                      );
                                    } else {
                                      Get.snackbar(
                                        "Erreur",
                                        "La suppression a échoué",
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          },
                        ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Fermer"),
                ),
              ],
            );
          });
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
                                "Syteme d'alarme     ",
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
