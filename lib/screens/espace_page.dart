import 'package:clone_spotify_mars/screens/profile_page.dart';
import 'package:flutter/material.dart';

class EspacePage extends StatelessWidget {
  const EspacePage({Key? key}) : super(key: key);

  Future<void> _showAddMaisonDialog(BuildContext context) async {
    return showDialog(
      context: context, // Correction : ajout du paramètre context
      builder: (context) {
        return AlertDialog(
          title: const Text("Ajouter une espace"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Nom de l'espace"),
              ),
              const SizedBox(height: 10),
              /*TextField(
                decoration: const InputDecoration(labelText: "Adresse"),
              ),*/
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
              onPressed: () {
                // Logique pour ajouter une maison
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
          "Liste Espace",
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
            // Ici, ajouter la liste des espaces si nécessaire
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => _showAddMaisonDialog(
              context,
            ), // Correction : passage du context
        child: const Icon(Icons.add, color: Color.fromARGB(255, 107, 12, 12)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
