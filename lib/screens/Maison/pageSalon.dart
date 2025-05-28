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
        title: const Text(
          "Salon",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.purple.shade700,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade50, Colors.white],
          ),
        ),
        child: Obx(() {
          if (controller.salons.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.purple.shade700,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.salons.length,
            itemBuilder: (context, index) {
              final salon = controller.salons[index];

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
                            "Salon  ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade800,
                            ),
                          ),
                          Icon(Icons.living, color: Colors.purple.shade300),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Environnement
                      _buildEnvironmentCard(
                        tempSalon: salon.tempSalon,
                        humSalon: salon.humSalon.toDouble(),
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
                            icon: Icons.arrow_upward_rounded,
                            label: "Ouvrir fenêtre",
                            value: salon.relayOpenWindowSalon,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              controller.updateRelayStatus(
                                id: salon.id,
                                relayOpenWindowSalon: value,
                                relayCloseWindowSalon:
                                    salon.relayCloseWindowSalon,
                                relayClimSalon: salon.relayClimSalon,
                              );
                            },
                          ),

                          _buildControlSwitch(
                            icon: Icons.arrow_downward_rounded,
                            label: "Fermer fenêtre",
                            value: salon.relayCloseWindowSalon,
                            activeColor: Colors.blue.shade800,
                            onChanged: (value) {
                              controller.updateRelayStatus(
                                id: salon.id,
                                relayOpenWindowSalon:
                                    salon.relayOpenWindowSalon,
                                relayCloseWindowSalon: value,
                                relayClimSalon: salon.relayClimSalon,
                              );
                            },
                          ),
                          _buildControlSwitch(
                            icon: Icons.ac_unit,
                            label: "Climatisation",
                            value: salon.relayClimSalon,
                            activeColor: Colors.teal,
                            onChanged: (value) {
                              controller.updateRelayStatus(
                                id: salon.id,
                                relayOpenWindowSalon:
                                    salon.relayOpenWindowSalon,
                                relayCloseWindowSalon:
                                    salon.relayCloseWindowSalon,
                                relayClimSalon: value,
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
    required double tempSalon,
    required double humSalon,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEnvironmentItem(
            icon: Icons.thermostat,
            value: "$tempSalon°C",
            label: "Température",
            color: Colors.red.shade400,
          ),
          _buildEnvironmentItem(
            icon: Icons.water_drop,
            value: "$humSalon%",
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
            color: Colors.purple.shade800,
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
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: value ? activeColor : Colors.grey.shade400,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
