import 'package:clone_spotify_mars/bottomappbar_page.dart';
import 'package:clone_spotify_mars/screens/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../controllers/espace_controller.dart';
import '../models/espace_model.dart';
import 'profile_page.dart';

class EspacePage extends StatefulWidget {
  const EspacePage({super.key, required this.token, required this.maisonId});
  final String token;
  final String maisonId;
  @override
  State<EspacePage> createState() => _EspacePageState();
}

class _EspacePageState extends State<EspacePage> {
  final controller = Get.put(EspaceController());
  late TextEditingController _nomController;
  late SharedPreferences prefs;
  late GlobalKey<FormState> _formkey;
  late List<EspaceModel> espaces = [];
  late String maisonId;

  Future<void> _loadEspaces() async {
    List<EspaceModel> list = await controller.getEspaces(widget.maisonId);
    setState(() {
      espaces = list;
    });
  }

  @override
  void initState() {
    _nomController = TextEditingController();
    _formkey = GlobalKey<FormState>();
    _loadEspaces();

    super.initState();
  }

  @override
  void dispose() {
    _nomController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _showAddEspaceDialog() async {
    _nomController.clear();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter une Espace"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: "Nom de la Espace",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nomController.text.isNotEmpty) {
                  var espace = EspaceModel(
                    id: const Uuid().v4(),
                    nom: _nomController.text,
                    maisonId: maisonId,
                  );

                  var result = await controller.createEspaceForMaison(espace);
                  if (result['success'] == true) {
                    _loadEspaces();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Erreur lors de l'ajout")),
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

  Future<void> _showUpdateEspaceDialog(EspaceModel espace) async {
    _nomController.clear();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier la Espace"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: "Nom de la espace",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nomController.text.isNotEmpty) {
                  espace.nom = _nomController.text;

                  var result = await controller.updateEspace(espace.id, espace);
                  if (result['success'] == true) {
                    _loadEspaces();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Erreur lors de la modification"),
                      ),
                    );
                  }
                }
              },
              child: const Text("Modifier"),
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
            "Mes Espaces",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Color.fromARGB(255, 61, 14, 214),
              ),
              onPressed: () async {
                await prefs.remove('token');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SigninPage()),
                  (_) => false,
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
              espaces.isEmpty
                  ? const Center(
                    child: Text(
                      "No Data \n Add New Task",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : Expanded(
                    child: FutureBuilder<List<EspaceModel>>(
                      future: controller.getEspaces(widget.maisonId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var espace = espaces[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(
                                    "assets/maison.png",
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                                title: Text(espace.nom),
                                trailing: Wrap(
                                  spacing: 10,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () {
                                        _showUpdateEspaceDialog(espace);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        var result = await controller
                                            .deleteEspace(espace.id);
                                        if (result) {
                                          _loadEspaces();
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Échec de la suppression",
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
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
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddEspaceDialog,
          backgroundColor: const Color.fromARGB(255, 209, 207, 207),
          child: const Icon(Icons.add, color: Color.fromARGB(255, 107, 12, 12)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBarPage(token: widget.token),
      ),
    );
  }
}
