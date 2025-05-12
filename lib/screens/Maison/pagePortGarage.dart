import 'package:clone_spotify_mars/controllers/Maison/portGarage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Facultatif si tu veux des icônes modernes

class PortGaragePage extends StatelessWidget {
  final String clientId;

  const PortGaragePage({Key? key, required this.clientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final portGarageController = Get.put(PortgarageController());
    portGarageController.getPortGarageByIdClient(clientId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes portes de garage"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Obx(() {
        if (portGarageController.garages.isEmpty) {
          return Center(
            child:
                portGarageController.garages.isEmpty
                    ? const CircularProgressIndicator() // Indicateur de chargement
                    : const Text(
                      "Aucune porte disponible.",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: portGarageController.garages.length,
          itemBuilder: (context, index) {
            final garage = portGarageController.garages[index];

            return Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadowColor: Colors.grey.withOpacity(0.5),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                leading: Icon(
                  garage.portGarage
                      ? Icons.garage_outlined
                      : Icons.garage_rounded,
                  size: 40,
                  color: garage.portGarage ? Colors.green : Colors.redAccent,
                ),

                subtitle: Text(
                  "La porte de garage est ${garage.portGarage ? "ouverte" : "fermée"}",
                  style: TextStyle(
                    color: garage.portGarage ? Colors.green : Colors.red,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                trailing: Switch.adaptive(
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.grey,
                  value: garage.portGarage,
                  onChanged: (value) {
                    portGarageController.updatePortGarageByIdGarage(
                      garage.id,
                      value,
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
