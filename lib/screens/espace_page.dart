import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../controllers/espace_controller.dart';
import '../models/espace_model.dart';
import 'profile_page.dart';

class EspacePage extends StatefulWidget {
  const EspacePage({Key? key}) : super(key: key);

  @override
  State<EspacePage> createState() => _EspacePageState();
}

class _EspacePageState extends State<EspacePage> {
  final controller = Get.put(EspaceController());
  late TextEditingController _nameController;
  late SharedPreferences prefs;
  late List<EspaceModel> espaces = [];
  late String maisonId = "";

  @override
  void initState() {
    _nameController = TextEditingController();
    _initPrefs();
    super.initState();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      maisonId = prefs.getString("maisonId") ?? "";
    });
    _loadEspaces();
  }

  Future<void> _loadEspaces() async {
    List<EspaceModel> list = await controller.getEspaces(maisonId);
    setState(() {
      espaces = list;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _showAddEspaceDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter un espace"),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Nom de l'espace"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                final espace = EspaceModel(
                  id: const Uuid().v4(),
                  maisonId: maisonId,
                  nom: _nameController.text,
                );
                var result = await controller.createEspace(espace);
                if (result["status"] == true) {
                  _loadEspaces();
                  _nameController.clear();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['error'] ?? "Échec de l'ajout"),
                    ),
                  );
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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(
          "Liste Espaces",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
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
            espaces.isEmpty
                ? const Expanded(
                  child: Center(
                    child: Text(
                      "Aucun espace ajouté",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: espaces.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset("assets/logo.png"),
                        title: Text(espaces[index].nom),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            var result = await controller.deleteEspace(
                              espaces[index].id,
                            );
                            bool deleted =
                                result['status'] ??
                                false; // Récupère le status comme booléen
                            if (deleted) {
                              _loadEspaces();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Suppression échouée"),
                                ),
                              );
                            }
                          },
                        ),
                      );
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
              icon: const Icon(
                Icons.home,
                color: Color.fromARGB(255, 61, 14, 214),
              ),
              onPressed: () {
                // Aller vers Accueil
              },
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(
                Icons.person,
                color: Color.fromARGB(255, 61, 14, 214),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(token: 'token'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEspaceDialog(context),
        child: const Icon(Icons.add, color: Color.fromARGB(255, 107, 12, 12)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
