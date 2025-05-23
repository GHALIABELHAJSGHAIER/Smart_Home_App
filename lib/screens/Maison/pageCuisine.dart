import 'package:clone_spotify_mars/controllers/Maison/cuisine_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class PageCuisine extends StatelessWidget {
//   final String espaceId;

//   const PageCuisine({super.key, required this.espaceId});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CuisineController());

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.getCuisineByIdEspace(espaceId);
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Cuisine",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.teal,
//         elevation: 0,
//       ),
//       body: Obx(() {
//         if (controller.cuisines.isEmpty) {
//           return Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
//             ),
//           );
//         }
//         return ListView.builder(
//           itemCount: controller.cuisines.length,
//           itemBuilder: (context, index) {
//             final cuisine = controller.cuisines[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Infos à gauche
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.local_fire_department,
//                               color: Colors.red,
//                             ),
//                             SizedBox(width: 8),
//                             Text(
//                               "Flamme: ${cuisine.flamme}",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Icon(Icons.fireplace, color: Colors.orange),
//                             SizedBox(width: 8),
//                             Text(
//                               "Gaz: ${cuisine.gaz}",
//                               style: TextStyle(color: Colors.grey[700]),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     // Switch à droite
//                     Switch(
//                       value: cuisine.relayInc,
//                       onChanged: (val) {
//                         controller.updateRelayStatus(cuisine.id, val);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }

class PageCuisine extends StatelessWidget {
  final String espaceId;
  const PageCuisine({super.key, required this.espaceId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CuisineController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCuisineByIdEspace(espaceId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cuisine",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.orange.shade700,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade50, Colors.white],
          ),
        ),
        child: Obx(() {
          if (controller.cuisines.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.orange.shade700,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.cuisines.length,
            itemBuilder: (context, index) {
              final cuisine = controller.cuisines[index];

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
                            "Cuisine  ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                          ),
                          Icon(Icons.kitchen, color: Colors.orange.shade300),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Détection
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildDetectionItem(
                              icon: Icons.local_fire_department,
                              value:
                                  (cuisine.flamme > 10) ? "Détectée" : "Aucune",
                              label: "Flamme",
                              color:
                                  (cuisine.flamme > 10)
                                      ? Colors.red
                                      : Colors.green,
                            ),
                            _buildDetectionItem(
                              icon: Icons.gas_meter,
                              value: (cuisine.gaz > 10) ? "Détecté" : "Aucun",
                              label: "Gaz",
                              color:
                                  (cuisine.gaz > 10)
                                      ? Colors.deepOrange
                                      : Colors.green,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Contrôles
                      Text(
                        "SYSTÈME DE VENTILATION",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 8),

                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.air, color: Colors.teal),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hotte aspirante",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Activez pour évacuer les fumées et gaz",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: cuisine.relayInc,
                              onChanged: (val) {
                                controller.updateRelayStatus(cuisine.id, val);
                              },
                              activeColor: Colors.teal,
                            ),
                          ],
                        ),
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

  Widget _buildDetectionItem({
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
