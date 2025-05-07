import 'package:flutter/material.dart';

class PageSalon extends StatelessWidget {
  final String espaceId;

  const PageSalon({super.key, required this.espaceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Salon")),
      body: Center(
        child: Text("Bienvenue dans l'espace Salon : $espaceId"),
      ),
    );
  }
}
