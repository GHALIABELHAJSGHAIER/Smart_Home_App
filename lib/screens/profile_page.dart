import 'package:clone_spotify_mars/controllers/auth_controller.dart';
import 'package:clone_spotify_mars/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signin_page.dart'; // Assurez-vous que vous avez une page SigninPage pour la connexion
import 'open_door_page.dart'; // Importer la page OpenDoorPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.token});
  final String token;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controller = Get.put(AuthController());
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late SharedPreferences prefs;

  late List<UserModel> items = [];
  late String clientId;

  // Initialiser les SharedPreferences
  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Charger les informations de l'utilisateur à partir du token
  Future<void> _loadUserList() async {
    List<UserModel> fetchedItems = await controller.getUserById(clientId);
    setState(() {
      items = fetchedItems;
    });
  }

  @override
  void initState() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    print(jwtDecodedToken);

    print("TOKEN PROFILLLLLL = ${widget.token}");
    print(jwtDecodedToken);
    print("Userid PROFILLLLLL = ${jwtDecodedToken['id']}");
    var email = jwtDecodedToken['email']?.toString() ?? '';
    print("EMAIL PROFILLLLLL = ${email}");
    clientId = jwtDecodedToken['id']; // Utiliser l'ID extrait du token
    _loadUserList();
    initSharedPref();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil Utilisateur",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgroundd.png"), // Image de fond
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar de l'utilisateur
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueAccent,
                child: const Icon(
                  Icons.person_2_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Affichage des informations utilisateur
              FutureBuilder<List<UserModel>>(
                future: controller.getUserById(clientId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    return Column(
                      children:
                          snapshot.data!.map((user) {
                            return Column(
                              children: [
                                Card(
                                  elevation: 4.0,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.person,
                                      color: Colors.blueAccent,
                                    ),
                                    title: Text(
                                      "Username: ${user.username}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 4.0,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.email,
                                      color: Colors.blueAccent,
                                    ),
                                    title: Text(
                                      "Email: ${user.email}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    );
                  } else {
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
                },
              ),

              // Déconnexion (bouton stylisé)
              ElevatedButton.icon(
                onPressed: () async {
                  await prefs.remove('token');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SigninPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.logout_outlined),
                label: const Text("Se Déconnecter"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 146, 116, 116),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 30.0,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Bouton pour aller vers la page OpenDoorPage
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OpenDoorPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.key),
                label: const Text("Ouvrir la porte"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Couleur du bouton
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 30.0,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*import 'package:clone_spotify_mars/controllers/auth_controller.dart';
import 'package:clone_spotify_mars/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signin_page.dart'; // Assurez-vous que vous avez une page SigninPage pour la connexion
import 'open_door_page.dart'; // Importer la page OpenDoorPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.token});
  final String token;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controller = Get.put(AuthController());
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late SharedPreferences prefs;
  late GlobalKey<FormState> _formkey;
  late List<UserModel> items = [];
  late String clientId;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadUserList() async {
    List<UserModel> fetchedItems = await controller.getUserById(clientId);
    /*List<UserModel> fetchedItems = await controller.getUserById(
      "67eea46ad413b6036625516c",
    );*/
    setState(() {
      items = fetchedItems;
    });
  }

  @override
  void initState() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _formkey = GlobalKey<FormState>();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
      print("TOKEN Prifel  = ${widget.token}");
    print(jwtDecodedToken);
    print("Userid  profile = ${jwtDecodedToken['id']}");
    //email = jwtDecodedToken['email']?.toString() ?? '';
    clientId = jwtDecodedToken['id'];

    super.initState();
    _loadUserList();
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil Utilisateur",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // Image de fond
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar de l'utilisateur
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueAccent,
                child: const Icon(
                  Icons.person_2_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
: Expanded(
  child: FutureBuilder<List<UserModel>>(
                      future: controller.getUserById(clientId),
                      /*future: controller.getMaisonList(
                        "67eea46ad413b6036625516c",
                      ),*/
              // Informations utilisateur dans des Cards
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.blueAccent),
                  title: Text(
                    "Username: $_usernameController",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.email, color: Colors.blueAccent),
                  title: Text(
                    "Email: $_emailController",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
),
              const SizedBox(height: 20),

              // Déconnexion (bouton stylisé)
              ElevatedButton.icon(
                onPressed: () async {
                  // Supprimer les informations de l'utilisateur lors de la déconnexion
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  await prefs.remove('username');
                  await prefs.remove('email');

                  // Naviguer vers la page de connexion après la déconnexion
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SigninPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.logout_outlined),
                label: const Text("Se Déconnecter"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 146, 116, 116),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 30.0,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Bouton pour aller vers la page OpenDoorPage
              ElevatedButton.icon(
                onPressed: () {
                  // Naviguer vers la page OpenDoorPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OpenDoorPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.key),
                label: const Text("Ouvrir la porte"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Couleur du bouton
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 30.0,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
                // Action pour revenir à la page d'accueil
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

*/
/**
 import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signin_page.dart'; // Assurez-vous que vous avez une page SigninPage pour la connexion
import 'open_door_page.dart'; // Importer la page OpenDoorPage
import 'package:jwt_decoder/jwt_decoder.dart'; // Pour décoder le JWT

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.token});
  final String token;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? email;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // Charger les informations de l'utilisateur depuis SharedPreferences et décoder le token
  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedToken = prefs.getString('token');  // On peut aussi récupérer le token stocké pour une utilisation future
    
    if (savedToken != null) {
      // Décoder le JWT pour récupérer les informations utilisateur
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(savedToken);
      setState(() {
        userId = jwtDecodedToken['id']; // Extraire l'ID utilisateur
        username = jwtDecodedToken['username']; // Assurez-vous d'avoir un champ 'username' dans le token
        email = jwtDecodedToken['email']; // De même, le champ 'email' dans le token
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil Utilisateur",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // Image de fond
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar de l'utilisateur
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueAccent,
                child: const Icon(
                  Icons.person_2_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Informations utilisateur dans des Cards
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.person, color: Colors.blueAccent),
                  title: Text(
                    "Username: ${username ?? 'Chargement...'}", // Affiche 'Chargement...' si l'info n'est pas encore chargée
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.email, color: Colors.blueAccent),
                  title: Text(
                    "Email: ${email ?? 'Chargement...'}", // Idem ici
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Déconnexion (bouton stylisé)
              ElevatedButton.icon(
                onPressed: () async {
                  // Supprimer les informations de l'utilisateur lors de la déconnexion
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  await prefs.remove('username');
                  await prefs.remove('email');

                  // Naviguer vers la page de connexion après la déconnexion
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SigninPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.logout_outlined),
                label: const Text("Se Déconnecter"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 146, 116, 116),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 30.0,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Bouton pour aller vers la page OpenDoorPage
              ElevatedButton.icon(
                onPressed: () {
                  // Naviguer vers la page OpenDoorPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OpenDoorPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.key),
                label: const Text("Ouvrir la porte"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Couleur du bouton
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 30.0,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
                // Action pour revenir à la page d'accueil
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

 */
