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
  //dima n7awiss bih
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
  late GlobalKey<FormState> _formkey;
  late List<MaisonModel> items = [];

  late String clientId;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadMaisonList() async {
    List<MaisonModel> fetchedItems = await controller.getMaisonList(clientId);
    /*List<MaisonModel> fetchedItems = await controller.getMaisonList(
      "67eea46ad413b6036625516c",
    );*/
    setState(() {
      items = fetchedItems;
    });
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _formkey = GlobalKey<FormState>();

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    print("TOKEN = ${widget.token}");
    print(jwtDecodedToken);
    print("Userid = ${jwtDecodedToken['id']}");
    //email = jwtDecodedToken['email']?.toString() ?? '';
    clientId = jwtDecodedToken['id'];

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
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text("Ajouter")));
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
              icon: const Icon(
                Icons.logout_outlined,
                color: Color.fromARGB(255, 61, 14, 214),
              ),
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
                      /*future: controller.getMaisonList(
                        "67eea46ad413b6036625516c",
                      ),*/
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder:
                                (context, index) => ListTile(
                                  leading: Image.asset("assets/maison.png"),
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
                icon: const Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 61, 14, 214),
                ),
                onPressed: () {
                  // Action pour Home
                },
              ),
              const SizedBox(width: 40), // Espace pour le FloatingActionButton
              IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 61, 14, 214),
                ),
                onPressed: () {
                  // Décoder le token pour obtenir l'ID de l'utilisateur
                  Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(
                    widget.token,
                  );
                  String userId = jwtDecodedToken['id'];
                  print("Token Home vers Profile = ");
                  print(widget.token);

                  // Naviguer vers la page ProfilePage avec le token
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProfilePage(
                            token:
                                widget
                                    .token, // Passez le token complet à la page ProfilePage
                            //userId: userId,       // Passez l'ID de l'utilisateur à la page ProfilePage
                          ),
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
