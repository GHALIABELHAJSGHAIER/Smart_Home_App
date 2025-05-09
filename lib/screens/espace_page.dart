import 'package:clone_spotify_mars/bottomappbar_page.dart';
import 'package:clone_spotify_mars/screens/appareil_page.dart';
import 'package:clone_spotify_mars/screens/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:clone_spotify_mars/screens/Maison/pageWC.dart';
import 'package:clone_spotify_mars/screens/Maison/pageCuisine.dart';
import 'package:clone_spotify_mars/screens/Maison/pageSalon.dart';
import 'package:clone_spotify_mars/screens/Maison/pageChambre.dart';

import '../controllers/espace_controller.dart';
import '../models/espace_model.dart';

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
  final List<String> _types = ["Cuisine", "WC", "Salon", "Chambre"];
  String? _selectedType;
  late GlobalKey<FormState> _formkey;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController();
    _selectedType = _types.first;
    _formkey = GlobalKey<FormState>();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void dispose() {
    _nomController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _showAddEspaceDialog() async {
    _nomController.clear();
    _selectedType = _types.first;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter un Espace"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: "Nom de l'espace"),
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items:
                    _types.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Type"),
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
                if (_nomController.text.isNotEmpty && _selectedType != null) {
                  final espace = EspaceModel(
                    id: const Uuid().v4(),
                    nom: _nomController.text,
                    type: _selectedType!,
                    maisonId: widget.maisonId,
                  );
                  var result = await controller.createEspaceForMaison(espace);
                  if (result['success'] == true) {
                    setState(() {});
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
    _nomController.text = espace.nom ?? '';
    _selectedType = espace.type ?? _types.first;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier l'Espace"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: "Nom de l'espace"),
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items:
                    _types.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: "Type"),
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
                if (_nomController.text.isNotEmpty && _selectedType != null) {
                  espace.nom = _nomController.text;
                  espace.type = _selectedType!;
                  var result = await controller.updateEspace(espace.id, espace);
                  if (result['success'] == true) {
                    setState(() {});
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backgroundd.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Center(child: Image.asset("assets/logo_text.png")),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<EspaceModel>>(
                  future: controller.getEspaces(widget.maisonId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var espace = snapshot.data![index];
                          return ListTile(
                            onTap: () {
                              switch (espace.type?.toLowerCase()) {
                                case "wc":
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => PageWc(espaceId: espace.id),
                                    ),
                                  );
                                  break;
                                case "cuisine":
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              PageCuisine(espaceId: espace.id),
                                    ),
                                  );
                                  break;
                                case "salon":
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => PageSalon(espaceId: espace.id),
                                    ),
                                  );
                                  break;
                                case "chambre":
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              PageChambre(espaceId: espace.id),
                                    ),
                                  );
                                  break;
                                default:
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Type d'espace inconnu"),
                                    ),
                                  );
                              }
                            },
                            leading: const CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage("assets/maison.png"),
                              backgroundColor: Color.fromARGB(0, 255, 236, 236),
                            ),
                            title: Text(
                              espace.nom ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              espace.type ?? '',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: Wrap(
                              spacing: 5,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                  onPressed:
                                      () => _showUpdateEspaceDialog(espace),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    var result = await controller.deleteEspace(
                                      espace.id,
                                    );
                                    if (result) {
                                      setState(() {});
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
                        child: Text(
                          "Aucun espace trouvé.\nAjoutez un nouvel espace.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
