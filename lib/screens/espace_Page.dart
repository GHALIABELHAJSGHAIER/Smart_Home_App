import 'package:flutter/material.dart';

class EspacePage extends StatelessWidget {
  final String title;

  EspacePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color(0xFFA67B5B),
      ),
      body: ListView.builder(
        itemCount: 10, // Remplace par la liste d'espaces réelle
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Espace ${index + 1}'),
            subtitle: Text('Description de l\'espace ${index + 1}'),
          );
        },
      ),
    );
  }
}
