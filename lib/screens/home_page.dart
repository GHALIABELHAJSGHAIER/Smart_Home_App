import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../controllers/maison_controller.dart';
import '../models/maison_model.dart';
import '../screens/signin_page.dart';
import '../screens/espace_page.dart';
import '../bottomappbar_page.dart';

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
  late TextEditingController _numCartEspController;
  late SharedPreferences prefs;
  late GlobalKey<FormState> _formkey;
  late List<MaisonModel> items = [];
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
    _numCartEspController = TextEditingController();
    _formkey = GlobalKey<FormState>();

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    clientId = jwtDecodedToken['id'];
    print("Client ID: $clientId");

    _loadMaisonList();
    initSharedPref();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _numCartEspController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _showAddMaisonDialog() async {
    _nameController.clear();
    _addressController.clear();
    _numCartEspController.clear();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter une Espace"),
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
              const SizedBox(height: 10),
              TextField(
                controller: _numCartEspController,
                decoration: const InputDecoration(labelText: "Nom Carte"),
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
                if (_nameController.text.isNotEmpty &&
                    _addressController.text.isNotEmpty &&
                    _numCartEspController.text.isNotEmpty) {
                  var maison = MaisonModel(
                    id: const Uuid().v4(),
                    name: _nameController.text,
                    address: _addressController.text,
                    numCartEsp: _numCartEspController.text,
                    clientId: clientId,
                  );

                  var result = await controller.createMaison(maison);
                  if (result['success'] == true) {
                    _loadMaisonList();
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


  Future<void> _showUpdateMaisonDialog(MaisonModel maison) async {
    _nameController.text = maison.name ?? '';
    _addressController.text = maison.address ?? '';
    _numCartEspController.text = maison.numCartEsp ?? '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier la Maison"),
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
              const SizedBox(height: 10),
              TextField(
                controller: _numCartEspController,
                decoration: const InputDecoration(labelText: "Nom Carte"),
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
                if (_nameController.text.isNotEmpty &&
                    _addressController.text.isNotEmpty) {
                  maison.name = _nameController.text;
                  maison.address = _addressController.text;
                  maison.numCartEsp = _numCartEspController.text;

                  var result = await controller.updateMaison(maison.id, maison);
                  if (result['success'] == true) {
                    _loadMaisonList();
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
            "Home Page",
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
              items.isEmpty
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
                    child: FutureBuilder<List<MaisonModel>>(
                      future: controller.getMaisonList(clientId),
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
                              var maison = snapshot.data![index];
                              return ListTile(
                                leading: GestureDetector(
                                  onTap: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString(
                                      "maisonId",
                                      maison.id,
                                    );

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => EspacePage(
                                              token: widget.token,
                                              maisonId: maison.id,
                                            ),
                                      ),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    radius: 40,
                                    backgroundImage: AssetImage(
                                      "assets/maison.png",
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),

                                title: Text(maison.name ?? ''),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(maison.address ?? ''),
                                    Text(maison.numCartEsp ?? ''),
                                  ],
                                ),
                                trailing: Wrap(
                                  spacing: 10,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () {
                                        _showUpdateMaisonDialog(maison);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        var result = await controller
                                            .deleteMaison(maison.id);
                                        if (result) {
                                          _loadMaisonList();
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
          onPressed: _showAddMaisonDialog,
          backgroundColor: const Color.fromARGB(255, 209, 207, 207),
          child: const Icon(Icons.add, color: Color.fromARGB(255, 107, 12, 12)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBarPage(token: widget.token),
      ),
    );
  }
}
