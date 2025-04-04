import 'package:clone_spotify_mars/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../controllers/maison_controller.dart';
import '../models/maison_model.dart';
import '../screens/signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.token});
  final String token;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(MaisonController());
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late SharedPreferences prefs;
  late List<MaisonModel> items = [];

  late String email;
  late String clientId;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadMaisonList() async {
    List<MaisonModel> fetchedItems = await controller.getMaisonList(clientId);
    setState(() {
      items = fetchedItems;
    });
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    try {
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
      email = jwtDecodedToken['email']?.toString() ?? '';
      clientId = jwtDecodedToken['_id']?.toString() ?? '';
    } catch (e) {
      email = '';
      clientId = '';
    }
    _loadMaisonList();
    initSharedPref();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    controller.dispose();
    super.dispose();
  }

  // Fonction pour afficher le formulaire d'ajout
  Future<void> _showAddMaisonDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter une Maison"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nom de la maison",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Adresse"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty &&
                    _addressController.text.isNotEmpty) {
                  var maison = MaisonModel(
                    id: const Uuid().v4(),
                    name: _nameController.text,
                    address: _addressController.text,
                    clientId: clientId,
                  );

                  var result = await controller.createMaison(maison);
                  if (result['success'] == true) {
                    _loadMaisonList(); // Recharger la liste après ajout
                    _nameController.clear();
                    _addressController.clear();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Échec de l'ajout")),
                    );
                  }
                }
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: const Text(
            "Home Page",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout_outlined, color: Color.fromARGB(255, 61, 14, 214)),
              onPressed: () async {
                await prefs.remove('token');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SigninPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Center(child: Image.asset("assets/logo_text.png")),
              const SizedBox(height: 10),

              // Afficher la liste ou un message si vide
              items.isEmpty
                  ? const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "No Data \n Add New Task",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : Expanded(
                    child: FutureBuilder<List<MaisonModel>>(
                      future: controller.getMaisonList(clientId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder:
                                (context, index) => ListTile(
                                  leading: Image.asset("assets/logo.png"),
                                  title: Text(snapshot.data![index].name!),
                                  subtitle: Text(
                                    snapshot.data![index].address!,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      print(
                                        "Delete item ${snapshot.data![index].id!}",
                                      );
                                      var result = await controller
                                          .deleteMaison(
                                            snapshot.data![index].id!,
                                          );
                                      if (result) {
                                        _loadMaisonList();
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Failed to delete"),
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Center(
                            child: Text("Failed to load data"),
                          );
                        }
                      },
                    ),
                  ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Color.fromARGB(255, 61, 14, 214)),
                onPressed: () {
                  // Action pour Home
                },
              ),
              const SizedBox(width: 40), // Espace pour le FloatingActionButton
              IconButton(
                icon: const Icon(Icons.person, color: Color.fromARGB(255, 61, 14, 214)),
                onPressed: () {
                  // Action pour Profil
                  // Naviguer vers la page ProfilePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddMaisonDialog, // Ouvre la boîte de dialogue d'ajout
          child: const Icon(Icons.add, color: Color.fromARGB(255, 107, 12, 12)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
///////////////////
/*
 import 'package:clone_spotify_mars/controllers/maison_controller.dart';
import 'package:clone_spotify_mars/models/maison_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../screens/signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.token});
  final String token;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(MaisonController());
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late SharedPreferences prefs;
  late List<MaisonModel> items = [];

  late String email;
  late String clientId;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadMaisonList() async {
    List<MaisonModel> fetchedItems = await controller.getMaisonList(clientId);
    setState(() {
      items = fetchedItems;
    });
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    try {
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
      email = jwtDecodedToken['email']?.toString() ?? '';
      clientId = jwtDecodedToken['_id']?.toString() ?? '';
    } catch (e) {
      email = '';
      clientId = '';
    }
    _loadMaisonList();
    initSharedPref();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: Text(
            "Home Page",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout_outlined, color: Colors.black),
              onPressed: () async {
                await prefs.remove('token');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SigninPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Center(child: Image.asset("assets/logo_text.png")),
              SizedBox(height: 10),

              // Display the list or a message if empty
              items.isEmpty
                  ? const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "No Data \n Add New Task",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : Expanded(
                    child: FutureBuilder<List<MaisonModel>>(
                      future: controller.getMaisonList(clientId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder:
                                ((context, index) => ListTile(
                                  leading: Image.asset("assets/logo.png"),
                                  title: Text(snapshot.data![index].name!),
                                  subtitle: Text(
                                    snapshot.data![index].address!,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      print(
                                        "Delete item ${snapshot.data![index].id!}",
                                      );
                                      // Deleting the Maison
                                      var result = await controller
                                          .deleteMaison(
                                            snapshot.data![index].id!,
                                          );
                                      if (result) {
                                        _loadMaisonList(); // Reload list after delete
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text("Failed to delete"),
                                          ),
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                )),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Center(child: Text("Failed to load data"));
                        }
                      },
                    ),
                  ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _displayTextInputDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Maison"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _addressController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  final String maisonId =
                      const Uuid().v4(); // Generate a unique ID
                  final maison = MaisonModel(
                    id: maisonId,
                    clientId: clientId,
                    name: _nameController.text,
                    address: _addressController.text,
                  );
                  var result = await controller.createMaison(maison);
                  if (result['status'] == true) {
                    _loadMaisonList(); // Reload list after adding new Maison
                    Navigator.pop(context); // Close the dialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['error'] ?? "Failed to add"),
                      ),
                    );
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }
}*/
