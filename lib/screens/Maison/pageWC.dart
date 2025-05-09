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
        title: const Text("Wc", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.wcs.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.wcs.length,
          itemBuilder: (context, index) {
            final wc = controller.wcs[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Temperature
                    Row(
                      children: [
                        Icon(Icons.thermostat, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          "Température : ${wc.temperature}°C",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Humidity
                    Row(
                      children: [
                        Icon(Icons.water_drop, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Humidité : ${wc.humidity}%",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Switches
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("Relay Solar Heat"),
                            Switch(
                              value: wc.relaySolarHeat,
                              onChanged: (val) {
                                controller.updateRelayStatus(
                                  wc.id,
                                  val,
                                  wc.relayHeat,
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Relay Heat"),
                            Switch(
                              value: wc.relayHeat,
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

// import 'package:flutter/material.dart';

// class PageWc extends StatelessWidget {
//   final String espaceId;

//   const PageWc({super.key, required this.espaceId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Page WC")),
//       body: Center(child: Text("Bienvenue dans l'espace WC : $espaceId")),
//     );
//   }
// }
// import 'package:clone_spotify_mars/controllers/Maison/wc_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PageWc extends StatelessWidget {
//   final String espaceId;

//   const PageWc({super.key, required this.espaceId});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(WcController());

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.getWcByIdEspace(espaceId);
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wc", style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.teal,
//         elevation: 0,
//       ),
//       body: Obx(() {
//         if (controller.wcs.isEmpty) {
//           return Center(
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
//             ),
//           );
//         }

//         return ListView.builder(
//           itemCount: controller.wcs.length,
//           itemBuilder: (context, index) {
//             final wc = controller.wcs[index];

//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Temperature
//                     Row(
//                       children: [
//                         Icon(Icons.thermostat, color: Colors.red),
//                         SizedBox(width: 8),
//                         Text(
//                           "Température : ${wc.temperature}°C",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8),
//                     // Humidité
//                     Row(
//                       children: [
//                         Icon(Icons.water_drop, color: Colors.blue),
//                         SizedBox(width: 8),
//                         Text(
//                           "Humidité : ${wc.humidity}%",
//                           style: TextStyle(color: Colors.grey[700]),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16),
//                     // Switches
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Text("Relay Solar Heat"),
//                             Switch(
//                               value: wc.relaySolarHeat,
//                               onChanged: (val) {
//                                 controller.updateRelayStatus(
//                                   wc.id,
//                                   val,
//                                   wc.relayHeat,
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Text("Relay Heat"),
//                             Switch(
//                               value: wc.relayHeat,
//                               onChanged: (val) {
//                                 controller.updateRelayStatus(
//                                   wc.id,
//                                   wc.relaySolarHeat,
//                                   val,
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
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
