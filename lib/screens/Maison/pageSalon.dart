// import 'package:flutter/material.dart';

// class PageSalon extends StatelessWidget {
//   final String espaceId;

//   const PageSalon({super.key, required this.espaceId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Salon")),
//       body: Center(
//         child: Text("Bienvenue dans l'espace Salon : $espaceId"),
//       ),
//     );
//   }
// }
import 'package:clone_spotify_mars/controllers/Maison/salon_controller.dart';
 import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageSalon extends StatelessWidget {
  final String espaceId;
  const PageSalon({super.key, required this.espaceId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SalonController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSalonByIdEspace(espaceId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Salon", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.salons.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.salons.length,
          itemBuilder: (context, index) {
            final salon = controller.salons[index];

            return Card(
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Salon ID : ${salon.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Température : ${salon.temperature}°C"),
                    Text("Humidité : ${salon.humidity}%"),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSwitch(
                          label: "Fenêtre ouverte",
                          value: salon.relayOpenWindow,
                          onChanged: (value) {
                            controller.updateRelayStatus(
                              id: salon.id,
                              relayOpenWindow: value,
                              relayCloseWindow: salon.relayCloseWindow,
                              relayClim: salon.relayClim,
                            );
                          },
                        ),
                        _buildSwitch(
                          label: "Fenêtre fermée",
                          value: salon.relayCloseWindow,
                          onChanged: (value) {
                            controller.updateRelayStatus(
                              id: salon.id,
                              relayOpenWindow: salon.relayOpenWindow,
                              relayCloseWindow: value,
                              relayClim: salon.relayClim,
                            );
                          },
                        ),
                        _buildSwitch(
                          label: "Clim",
                          value: salon.relayClim,
                          onChanged: (value) {
                            controller.updateRelayStatus(
                              id: salon.id,
                              relayOpenWindow: salon.relayOpenWindow,
                              relayCloseWindow: salon.relayCloseWindow,
                              relayClim: value,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildSwitch({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.teal,
        ),
      ],
    );
  }
}

