import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signin_page.dart'; // Assurez-vous que vous avez une page SigninPage pour la connexion
import 'open_door_page.dart'; // Importer la page OpenDoorPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? email;
  String? password;
  bool _isPasswordVisible = false; // Variable pour savoir si le mot de passe est visible

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // Charger les informations de l'utilisateur depuis SharedPreferences
  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      email = prefs.getString('email');
      password = prefs.getString('password');
    });
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
        padding: const EdgeInsets.all(10), // Padding autour du contenu
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
                    "Username: $username",
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
                    "Email: $email",
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
                  leading: Icon(Icons.lock, color: Colors.blueAccent),
                  title: TextField(
                    obscureText: !_isPasswordVisible, // Contrôle de la visibilité du mot de passe
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                    ),
                    controller: TextEditingController(text: password),
                    readOnly: true, // Empêche l'édition du mot de passe
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Déconnexion (bouton stylisé)
              ElevatedButton.icon(
                onPressed: () async {
                  // Supprimer les informations de l'utilisateur lors de la déconnexion
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  await prefs.remove('username');
                  await prefs.remove('email');
                  await prefs.remove('password');

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
                  backgroundColor: const Color.fromARGB(255, 146, 116, 116), // Couleur du bouton
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
                    MaterialPageRoute(builder: (context) => const OpenDoorPage()),
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
              icon: const Icon(Icons.home, color: Color.fromARGB(255, 61, 14, 214)),
              onPressed: () {
                // Action pour revenir à la page d'accueil
                Navigator.pop(
                  context,
                ); // Cela reviendra à la page précédente, supposée être la page d'accueil
              },
            ),
          ],
        ),
      ),
    );
  }
}
