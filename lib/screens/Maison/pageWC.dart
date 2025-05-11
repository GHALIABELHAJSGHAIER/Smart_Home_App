import 'package:clone_spotify_mars/controllers/Maison/wc_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageWc extends StatelessWidget {
  final String espaceId;
  const PageWc({super.key, required this.espaceId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WcController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getWcByIdEspace(espaceId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Salle de bain",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Obx(() {
          if (controller.wcs.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.wcs.length,
            itemBuilder: (context, index) {
              final wc = controller.wcs[index];

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
                            "Salle de bain ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          Icon(Icons.bathtub, color: Colors.blue.shade300),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Environnement
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildEnvironmentItem(
                              icon: Icons.thermostat,
                              value: "${wc.temperature}°C",
                              label: "Température",
                              color: Colors.red.shade400,
                            ),
                            _buildEnvironmentItem(
                              icon: Icons.water_drop,
                              value: "${wc.humidity}%",
                              label: "Humidité",
                              color: Colors.blue.shade400,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Contrôles
                      Text(
                        "SYSTÈME DE CHAUFFAGE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 8),

                      Column(
                        children: [
                          _buildHeatingControl(
                            icon: Icons.wb_sunny,
                            label: "Chauffage solaire",
                            value: wc.relaySolarHeat,
                            activeColor: Colors.orange,
                            onChanged: (val) {
                              controller.updateRelayStatus(
                                wc.id,
                                val,
                                wc.relayHeat,
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          _buildHeatingControl(
                            icon: Icons.heat_pump,
                            label: "Chauffage électrique",
                            value: wc.relayHeat,
                            activeColor: Colors.red,
                            onChanged: (val) {
                              controller.updateRelayStatus(
                                wc.id,
                                wc.relaySolarHeat,
                                val,
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
            color: Colors.blue.shade800,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildHeatingControl({
    required IconData icon,
    required String label,
    required bool value,
    required Color activeColor,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: value ? activeColor : Colors.grey.shade400),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  value ? "Activé" : "Désactivé",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: activeColor),
        ],
      ),
    );
  }
}
