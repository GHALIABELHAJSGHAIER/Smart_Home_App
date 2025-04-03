import 'package:flutter/material.dart';

class OpenDoorPage extends StatelessWidget {
  const OpenDoorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ouvrir la porte"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // Image de fond
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              // Logic to open door
              // Ajoutez ici votre logique pour ouvrir la porte
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Porte ouverte!')),
              );
            },
            child: const Text("Ouvrir la porte"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Couleur du bouton
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
