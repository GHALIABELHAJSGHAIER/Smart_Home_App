// import 'package:clone_spotify_mars/screens/profile_page.dart';
// import 'package:flutter/material.dart';

// class AppareilPage extends StatefulWidget {
//   const AppareilPage({super.key, required this.token, required this.id});
//   final String token;
//   final String id;
//   @override
//   _AppareilPageState createState() => _AppareilPageState();
// }

// Future<void> _showAddAppareilDialog(BuildContext context) async {
//   return showDialog(
//     context: context, // Correction : ajout du paramètre context
//     builder: (context) {
//       return AlertDialog(
//         title: const Text("Ajouter une Appareil"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               decoration: const InputDecoration(labelText: "Nom de l'Appareil"),
//             ),
//             const SizedBox(height: 10),
//             TextField(decoration: const InputDecoration(labelText: "Etat")),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("Annuler"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Logique pour ajouter une maison
//               Navigator.pop(context);
//             },
//             child: const Text("Ajouter"),
//           ),
//         ],
//       );
//     },
//   );
// }

// class _AppareilPageState extends State<AppareilPage> {
//   bool isLightOn = false;
//   bool isAcOn = false;
//   bool isTvOn = false;
//   bool isFanOn = false;

//   get token => null;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.black,
//         backgroundColor: Colors.white,
//         title: const Text(
//           "Appareils - Nom Espace",
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/background.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Température = 24.9°",
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//                 Text(
//                   "Humidité = 69%",
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//                 SizedBox(height: 20),
//                 Expanded(
//                   child: GridView.count(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     childAspectRatio: 1.2,
//                     children: [
//                       _buildDeviceCard(
//                         "Smart Light",
//                         Icons.lightbulb,
//                         isLightOn,
//                         (value) {
//                           setState(() => isLightOn = value);
//                         },
//                       ),
//                       _buildDeviceCard("Smart AC", Icons.ac_unit, isAcOn, (
//                         value,
//                       ) {
//                         setState(() => isAcOn = value);
//                       }),
//                       _buildDeviceCard("Smart TV", Icons.tv, isTvOn, (value) {
//                         setState(() => isTvOn = value);
//                       }),
//                       _buildDeviceCard("Smart Fan", Icons.toys, isFanOn, (
//                         value,
//                       ) {
//                         setState(() => isFanOn = value);
//                       }),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8.0,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: const Icon(
//                 Icons.home,
//                 color: Color.fromARGB(255, 61, 14, 214),
//               ),
//               onPressed: () {
//                 // Action pour Home
//               },
//             ),
//             const SizedBox(width: 40), // Espace pour le FloatingActionButton
//             IconButton(
//               icon: const Icon(
//                 Icons.person,
//                 color: Color.fromARGB(255, 61, 14, 214),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProfilePage(token: token),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:
//             () => _showAddAppareilDialog(
//               context,
//             ), // Correction : passage du context
//         child: const Icon(Icons.add, color: Color.fromARGB(255, 107, 12, 12)),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }

//   Widget _buildDeviceCard(
//     String title,
//     IconData icon,
//     bool isOn,
//     Function(bool) onChanged,
//   ) {
//     return Card(
//       color: isOn ? Colors.black : Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 40, color: isOn ? Colors.white : Colors.black),
//             SizedBox(height: 10),
//             Text(
//               title,
//               style: TextStyle(color: isOn ? Colors.white : Colors.black),
//             ),
//             Switch(
//               value: isOn,
//               onChanged: onChanged,
//               activeColor: Colors.green,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//////////222222222222
// import 'package:clone_spotify_mars/bottomappbar_page.dart';
// import 'package:clone_spotify_mars/screens/profile_page.dart';
// import 'package:flutter/material.dart';

// // ... [imports identiques]

// class AppareilPage extends StatefulWidget {
//   const AppareilPage({super.key, required this.token, required this.id});
//   final String token;
//   final String id;
//   @override
//   _AppareilPageState createState() => _AppareilPageState();
// }

// class _AppareilPageState extends State<AppareilPage> {
//   bool isLightOn = false;
//   bool isAcOn = false;
//   bool isTvOn = false;
//   bool isFanOn = false;

//   final List<IconData> _icons = [
//     Icons.lightbulb,
//     Icons.ac_unit,
//     Icons.tv,
//     Icons.toys,
//     Icons.kitchen,
//     Icons.wifi,
//   ];

//   IconData _selectedIcon = Icons.lightbulb;

//   final TextEditingController _nomController = TextEditingController();
//   final TextEditingController _adresseController = TextEditingController();

//   Future<void> _showAddAppareilDialog(BuildContext context) async {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Text(
//             "Ajouter un Appareil",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _nomController,
//                   decoration: InputDecoration(
//                     labelText: "Nom de l'Appareil",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: _adresseController,
//                   decoration: InputDecoration(
//                     labelText: "Etat",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 DropdownButtonFormField<IconData>(
//                   value: _selectedIcon,
//                   decoration: InputDecoration(
//                     labelText: "Icône",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   items:
//                       _icons.map((icon) {
//                         return DropdownMenuItem(
//                           value: icon,
//                           child: Row(
//                             children: [
//                               Icon(icon),
//                               const SizedBox(width: 10),
//                               Text(icon.toString().split('.').last),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                   onChanged: (icon) {
//                     setState(() => _selectedIcon = icon!);
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Annuler"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 61, 14, 214),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: () {
//                 String nom = _nomController.text;
//                 String adresse = _adresseController.text;
//                 print("Nom: $nom");
//                 print("Etat: $adresse");
//                 print("Icône: $_selectedIcon");
//                 _nomController.clear();
//                 _adresseController.clear();
//                 Navigator.pop(context);
//               },
//               child: const Text("Ajouter"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.black,
//         backgroundColor: Colors.white,
//         title: const Text(
//           "Appareils - Nom Espace",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
//         ),
//         centerTitle: true,
//         elevation: 1,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/backgroundd.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildInfoRow("Température", "24.9°"),
//                 _buildInfoRow("Humidité", "69%"),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: GridView.count(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 14,
//                     mainAxisSpacing: 14,
//                     childAspectRatio: 1.1,
//                     children: [
//                       _buildDeviceCard(
//                         "Smart Light",
//                         Icons.lightbulb,
//                         isLightOn,
//                         (v) => setState(() => isLightOn = v),
//                       ),
//                       _buildDeviceCard(
//                         "Smart AC",
//                         Icons.ac_unit,
//                         isAcOn,
//                         (v) => setState(() => isAcOn = v),
//                       ),
//                       _buildDeviceCard(
//                         "Smart TV",
//                         Icons.tv,
//                         isTvOn,
//                         (v) => setState(() => isTvOn = v),
//                       ),
//                       _buildDeviceCard(
//                         "Smart Fan",
//                         Icons.toys,
//                         isFanOn,
//                         (v) => setState(() => isFanOn = v),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       ///////////
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddAppareilDialog(context),
//         backgroundColor: const Color.fromARGB(255, 209, 207, 207),
//         child: const Icon(Icons.add, color: Color.fromARGB(255, 107, 12, 12)),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBarPage(token: widget.token),
//     );
//   }

//   Widget _buildDeviceCard(
//     String title,
//     IconData icon,
//     bool isOn,
//     Function(bool) onChanged,
//   ) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         color: isOn ? Colors.black : Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: isOn ? Colors.black : Colors.grey.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 40,
//             color: isOn ? Colors.white : Color.fromARGB(255, 61, 14, 214),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             title,
//             style: TextStyle(
//               color: isOn ? Colors.white : Colors.black,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Switch(value: isOn, onChanged: onChanged, activeColor: Colors.green),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Text(
//         "$label : $value",
//         style: const TextStyle(
//           fontSize: 16,
//           color: Colors.black,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//     );
//   }
// }
//////////33333
///

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clone_spotify_mars/bottomappbar_page.dart';

class AppareilPage extends StatefulWidget {
  const AppareilPage({super.key, required this.token, required this.id});
  final String token;
  final String id;

  @override
  _AppareilPageState createState() => _AppareilPageState();
}

class _AppareilPageState extends State<AppareilPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _etatController = TextEditingController();

  final List<List<dynamic>> mySmartDevices = [
    ["Smart Light", "assets/appareil/light.svg", false],
    ["Smart AC", "assets/appareil/aircondition.svg", false],
    ["Smart TV", "assets/appareil/tv.svg", false],
    ["Smart Fan", "assets/appareil/fan.svg", false],
  ];

  Future<void> _showAddAppareilDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Ajouter un Appareil",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    labelText: "Nom de l'Appareil",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _etatController,
                  decoration: InputDecoration(
                    labelText: "Etat",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 61, 14, 214),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                String nom = _nomController.text;
                String etat = _etatController.text;
                print("Nom: $nom");
                print("Etat: $etat");
                _nomController.clear();
                _etatController.clear();
                Navigator.pop(context);
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(
          "Appareils - Nom Espace",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgroundd.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow("Température", "24.9°"),
                _buildInfoRow("Humidité", "69%"),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: mySmartDevices.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.1,
                        ),
                    itemBuilder: (context, index) {
                      return _buildDeviceCard(
                        mySmartDevices[index][0],
                        mySmartDevices[index][1],
                        mySmartDevices[index][2],
                        (value) {
                          setState(() {
                            mySmartDevices[index][2] = value;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAppareilDialog(context),
        backgroundColor: const Color.fromARGB(255, 209, 207, 207),
        child: const Icon(Icons.add, color: Color.fromARGB(255, 107, 12, 12)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBarPage(token: widget.token),
    );
  }

  Widget _buildDeviceCard(
    String title,
    String svgPath,
    bool isOn,
    Function(bool) onChanged,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isOn ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isOn ? Colors.black : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgPath,
            width: 40,
            height: 40,
            color: isOn ? Colors.white : const Color.fromARGB(255, 61, 14, 214),
            placeholderBuilder: (context) => const CircularProgressIndicator(),
          ),

          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: isOn ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(value: isOn, onChanged: onChanged, activeColor: Colors.green),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "$label : $value",
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
