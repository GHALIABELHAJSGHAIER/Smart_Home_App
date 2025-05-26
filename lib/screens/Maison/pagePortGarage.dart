import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:clone_spotify_mars/controllers/Maison/portGarage_controller.dart';
//import 'package:clone_spotify_mars/models/Maison/portGarage_model.dart';

class PortGaragePage extends StatefulWidget {
  final String maisonId;

  const PortGaragePage({Key? key, required this.maisonId}) : super(key: key);

  @override
  _PortGaragePageState createState() => _PortGaragePageState();
}

class _PortGaragePageState extends State<PortGaragePage> {
  final PortgarageController portGarageController = Get.put(
    PortgarageController(),
  );
  String? selectedGarageId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      portGarageController.getPortGarageByIdMaison(widget.maisonId);
    });
  }

  void _showHistoryBottomSheet(BuildContext context, String garageId) {
    final controller = Get.find<PortgarageController>();
    controller.getHistoriqueByGarageId(garageId);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Obx(() {
          final historique =
              controller.historique
                  .where((h) => h.garageId == garageId)
                  .toList()
                ..sort((a, b) => b.date.compareTo(a.date));

          return AlertDialog(
            title: const Text("Historique"),
            content: Container(
              width: double.maxFinite,
              child:
                  historique.isEmpty
                      ? const Text("Aucun historique disponible")
                      : ListView.builder(
                        shrinkWrap: true,
                        itemCount: historique.length,
                        itemBuilder: (context, index) {
                          final item = historique[index];
                          return ListTile(
                            leading: Icon(
                              item.etat ? Icons.lock_open : Icons.lock,
                              color: item.etat ? Colors.green : Colors.red,
                            ),
                            title: Text(item.etat ? "Ouvert" : "Fermé"),
                            subtitle: Text(
                              DateFormat('dd/MM HH:mm').format(item.date),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes portes de garage"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              portGarageController.getPortGarageByIdMaison(widget.maisonId);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (portGarageController.garages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: portGarageController.garages.length,
          itemBuilder: (context, index) {
            final garage = portGarageController.garages[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.garage,
                              size: 30,
                              color:
                                  garage.portGarage ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Porte de garage #${index + 1}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: garage.portGarage,
                          onChanged: (value) {
                            portGarageController.updatePortGarageByIdGarage(
                              garage.id,
                              value,
                            );
                          },
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "État: ${garage.portGarage ? "Ouvert" : "Fermé"}",
                      style: TextStyle(
                        color: garage.portGarage ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed:
                            () => _showHistoryBottomSheet(context, garage.id),
                        child: const Text("Voir l'historique"),
                      ),
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
}
