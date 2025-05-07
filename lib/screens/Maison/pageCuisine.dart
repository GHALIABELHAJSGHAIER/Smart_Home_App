// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:clone_spotify_mars/controllers/cuisine_controller.dart';

// class PageCuisine extends StatelessWidget {
//   final String espaceId;

//   const PageCuisine({super.key, required this.espaceId});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CuisineController());

//     // Initialiser l'ID de l’espace
//     controller.setCuisineId(espaceId);

//     return Scaffold(
//       appBar: AppBar(title: Text("Cuisine - $espaceId")),
//       body: Obx(() {
//         final cuisine = controller.cuisineModel.value;

//         if (cuisine == null) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Bienvenue dans l'espace Cuisine",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 "Flamme : ${cuisine.flamme}°",
//                 style: TextStyle(fontSize: 18),
//               ),
//               Text("Gaz : ${cuisine.gaz}", style: TextStyle(fontSize: 18)),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Text("RelayInc: ", style: TextStyle(fontSize: 18)),
//                   Switch(
//                     value: cuisine.relayInc,
//                     onChanged: (_) => controller.updateRelay(),
//                   ),
//                   Text(cuisine.relayInc ? "ON" : "OFF"),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

///////////////////////
import 'package:flutter/material.dart';

class PageCuisine extends StatelessWidget {
  final String espaceId;

  const PageCuisine({super.key, required this.espaceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cuisine")),
      body: Center(child: Text("Bienvenue dans l'espace Cuisine : $espaceId")),
    );
  }
}

////////////////////////////////////////////
// import 'package:clone_spotify_mars/controllers/cuisine_controller.dart';
// import 'package:clone_spotify_mars/smart_device_box.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PageCuisine extends StatefulWidget {
//   final String cuisineId;

//   const PageCuisine({super.key, required this.cuisineId});

//   @override
//   State<PageCuisine> createState() => _PageCuisineState();
// }

// class _PageCuisineState extends State<PageCuisine> {
//   final controller = Get.put(CuisineController());
//   final double horizontalPadding = 30;
//   final double verticalPadding = 10;

//   List mySmartDevices = [
//     ["Smart Light", "assets/light.svg", false],
//     ["Smart AC", "assets/aircondition.svg", false],
//     ["Smart TV", "assets/tv.svg", false],
//     ["Smart Fan", "assets/fan.svg", false],
//   ];

//   void powerSwitchChanged(bool value, int index) {
//     setState(() {
//       mySmartDevices[index][2] = value;
//     });

//     if (index == 0) {
//       controller.updateRelay();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller.setCuisineId(widget.cuisineId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Cuisine - ${widget.cuisineId}"),
//         ),
//         backgroundColor: Colors.grey[300],
//         body: Obx(() {
//           final cuisine = controller.cuisineModel.value;

//           if (cuisine != null) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: horizontalPadding,
//                     vertical: verticalPadding,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Image.asset("assets/menu.png", height: 35),
//                       Icon(Icons.kitchen, size: 45, color: Colors.grey[800]),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Bienvenue dans la cuisine",
//                         style: TextStyle(fontSize: 20, color: Colors.grey[700]),
//                       ),
//                       Text(
//                         "Cuisine ID: ${widget.cuisineId}",
//                         style: GoogleFonts.bebasNeue(fontSize: 40),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                   child: Divider(color: Colors.grey[800], thickness: 1),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                   child: Text(
//                     "Appareils Intelligents",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 24,
//                       color: Colors.grey[800],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                   child: Text(
//                     "Flamme = ${cuisine.flamme}°",
//                     style: TextStyle(fontSize: 20, color: Colors.grey[700]),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                   child: Text(
//                     "Gaz = ${cuisine.gaz}",
//                     style: TextStyle(fontSize: 20, color: Colors.grey[700]),
//                   ),
//                 ),
//                 Expanded(
//                   child: GridView.builder(
//                     itemCount: mySmartDevices.length,
//                     padding: const EdgeInsets.all(15),
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 1 / 1.2,
//                     ),
//                     itemBuilder: (context, index) {
//                       return SmartDeviceBox(
//                         smartDeviceName: mySmartDevices[index][0],
//                         iconPath: mySmartDevices[index][1],
//                         powerOn: mySmartDevices[index][2],
//                         onChanged: (value) => powerSwitchChanged(value, index),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         }),
//       ),
//     );
//   }
// }
