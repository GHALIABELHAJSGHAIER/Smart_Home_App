import 'package:flutter/material.dart';

class PageChambre extends StatelessWidget {
  final String espaceId;

  const PageChambre({super.key, required this.espaceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chambre")),
      body: Center(child: Text("Bienvenue dans l'espace Chambre : $espaceId")),
    );
  }
}
