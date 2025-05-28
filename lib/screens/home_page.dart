import 'package:clone_spotify_mars/bottomappbar_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:clone_spotify_mars/controllers/weather_controller.dart';
import 'package:clone_spotify_mars/models/weather_model.dart';
import 'package:clone_spotify_mars/controllers/maison_controller.dart';
import 'package:clone_spotify_mars/models/maison_model.dart';
import 'package:clone_spotify_mars/screens/signin_page.dart';
import 'package:clone_spotify_mars/screens/espace_page.dart';

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
  final _formKey = GlobalKey<FormState>();
  late String clientId;
  WeatherModel? weather;
  final WeatherService weatherService = WeatherService();

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _fetchWeather() async {
    const double latitude = 36.8065;
    const double longitude = 10.1815;

    final fetchedWeather = await weatherService.fetchWeather(
      latitude,
      longitude,
    );
    if (fetchedWeather != null) {
      setState(() {
        weather = fetchedWeather;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _numCartEspController = TextEditingController();

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    clientId = jwtDecodedToken['id'];

    initSharedPref();
    _fetchWeather();
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
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Nom de la maison",
                    ),
                    validator:
                        (value) => value!.isEmpty ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: "Adresse"),
                    validator:
                        (value) => value!.isEmpty ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _numCartEspController,
                    decoration: const InputDecoration(labelText: "Nom Carte"),
                    validator:
                        (value) => value!.isEmpty ? "Champ requis" : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var maison = MaisonModel(
                    id: const Uuid().v4(),
                    name: _nameController.text,
                    address: _addressController.text,
                    numCartEsp: _numCartEspController.text,
                    clientId: clientId,
                  );
                  var result = await controller.createMaison(maison);
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

  Future<void> _showUpdateMaisonDialog(MaisonModel maison) async {
    _nameController.text = maison.name ?? '';
    _addressController.text = maison.address ?? '';
    _numCartEspController.text = maison.numCartEsp ?? '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier la Maison"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Nom de la maison",
                    ),
                    validator:
                        (value) => value!.isEmpty ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: "Adresse"),
                    validator:
                        (value) => value!.isEmpty ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _numCartEspController,
                    decoration: const InputDecoration(labelText: "Nom Carte"),
                    validator:
                        (value) => value!.isEmpty ? "Champ requis" : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  maison.name = _nameController.text;
                  maison.address = _addressController.text;
                  maison.numCartEsp = _numCartEspController.text;

                  var result = await controller.updateMaison(maison.id, maison);
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
        /*floatingActionButton: FloatingActionButton(
          onPressed: _showAddMaisonDialog,
          child: const Icon(Icons.add),
        ),*/
        body: Container(
          padding: const EdgeInsets.all(10),
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
              if (weather != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wb_sunny, color: Colors.orange),
                      const SizedBox(width: 10),
                      Text(
                        'Température: ${weather!.temperature}°C',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: FutureBuilder<List<MaisonModel>>(
                  future: controller.getMaisonList(clientId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      final items = snapshot.data!;
                      if (items.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Data \n Add New Task",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var maison = items[index];
                          return GestureDetector(
                            onTap: () async {
                              await prefs.setString("maisonId", maison.id);
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
                            child: Card(
                              margin: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: const AssetImage(
                                      "assets/maison.png",
                                    ),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3),
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              maison.name ?? '',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              maison.address ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              maison.numCartEsp ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onPressed:
                                                () => _showUpdateMaisonDialog(
                                                  maison,
                                                ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            onPressed: () async {
                                              var result = await controller
                                                  .deleteMaison(maison.id);
                                              if (result) {
                                                setState(() {});
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Erreur lors de la suppression",
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("Erreur de chargement."));
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
