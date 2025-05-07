import 'package:flutter/material.dart';

class PageWC extends StatelessWidget {
  final String espaceId;

  const PageWC({super.key, required this.espaceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page WC")),
      body: Center(child: Text("Bienvenue dans l'espace WC : $espaceId")),
    );
  }
}
