// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class PageCuisine extends StatelessWidget {
//   final String espaceId;

//   const PageCuisine({super.key, required this.espaceId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Cuisine")),
//       body: Center(child: Text("Bienvenue dans l'espace Cuisine : $espaceId")),
//     );
//   }
// }

import 'package:clone_spotify_mars/controllers/Maison/cuisine_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.cuisines.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.cuisines.length,
          itemBuilder: (context, index) {
            final cuisine = controller.cuisines[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Infos à gauche
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Flamme: ${cuisine.flamme}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.fireplace, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              "Gaz: ${cuisine.gaz}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Switch à droite
                    Switch(
                      value: cuisine.relayInc,
                      onChanged: (val) {
                        controller.updateRelayStatus(cuisine.id, val);
                      },
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
