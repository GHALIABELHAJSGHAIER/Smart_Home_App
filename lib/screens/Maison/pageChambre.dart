import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:clone_spotify_mars/controllers/Maison/chambre_controller.dart'; // adapte ce chemin si nécessaire

class PageChambre extends StatelessWidget {
  final String espaceId;
  const PageChambre({super.key, required this.espaceId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChambreController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getChambreByIdEspace(espaceId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chambre",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: Obx(() {
          if (controller.chambres.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.indigo.shade700,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.chambres.length,
            itemBuilder: (context, index) {
              final chambre = controller.chambres[index];

              return Container(
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chambre  ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade800,
                            ),
                          ),
                          Icon(
                            Icons.bedroom_parent,
                            color: Colors.indigo.shade300,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Environnement
                      _buildEnvironmentCard(
                        tempChambre: chambre.tempChambre.toDouble(),
                        humChambre: chambre.humChambre.toDouble(),
                      ),

                      SizedBox(height: 24),

                      // Contrôles
                      Text(
                        "CONTROLES",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 8),

                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        children: [
                          _buildControlSwitch(
                            icon: Icons.arrow_upward_rounded, // nouvelle icône
                            label: "Ouvrir fenêtre",
                            value: chambre.relayOpenWindow,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              controller.updateRelayStatus(
                                chambre.id,
                                value,
                                chambre.relayCloseWindow,
                                chambre.relayClimChambre,
                                chambre.relayLamp,
                              );
                            },
                          ),

                          _buildControlSwitch(
                            icon: Icons.ac_unit,
                            label: "Climatisation",
                            value: chambre.relayClimChambre,
                            activeColor: Colors.teal,
                            onChanged: (value) {
                              controller.updateRelayStatus(
                                chambre.id,
                                chambre.relayOpenWindow,
                                chambre.relayCloseWindow,
                                value,
                                chambre.relayLamp,
                              );
                            },
                          ),
                          _buildControlSwitch(
                            icon: Icons.lightbulb,
                            label: "Éclairage",
                            value: chambre.relayLamp,
                            activeColor: Colors.amber,
                            onChanged: (value) {
                              controller.updateRelayStatus(
                                chambre.id,
                                chambre.relayOpenWindow,
                                chambre.relayCloseWindow,
                                chambre.relayClimChambre,
                                value,
                              );
                            },
                          ),
                          _buildControlSwitch(
                            icon:
                                Icons.arrow_downward_rounded, // nouvelle icône
                            label: "Fermer fenêtre",
                            value: chambre.relayCloseWindow,
                            activeColor: Colors.green,
                            onChanged: (value) {
                              controller.updateRelayStatus(
                                chambre.id,
                                chambre.relayOpenWindow,
                                value,
                                chambre.relayClimChambre,
                                chambre.relayLamp,
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
      ),
    );
  }

  Widget _buildEnvironmentCard({
    required double tempChambre,
    required double humChambre,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEnvironmentItem(
            icon: Icons.thermostat,
            value: "$tempChambre°C",
            label: "Température",
            color: Colors.red.shade400,
          ),
          _buildEnvironmentItem(
            icon: Icons.water_drop,
            value: "$humChambre%",
            label: "Humidité",
            color: Colors.blue.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.indigo.shade800,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildControlSwitch({
    required IconData icon,
    required String label,
    required bool value,
    required Color activeColor,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: value ? activeColor : Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Switch(value: value, onChanged: onChanged, activeColor: activeColor),
        ],
      ),
    );
  }
}
