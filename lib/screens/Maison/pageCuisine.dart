import 'package:flutter/material.dart';

class PageCuisine extends StatelessWidget {
  final String espaceId;

  const PageCuisine({super.key, required this.espaceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cuisine")),
      body: Center(
        child: Text("Bienvenue dans l'espace Cuisine : $espaceId"),
      ),
    );
  }
}
