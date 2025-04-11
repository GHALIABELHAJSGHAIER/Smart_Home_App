import 'package:flutter/material.dart';
import '../screens/profile_page.dart';

class BottomAppBarPage extends StatelessWidget {
  final String token;

  const BottomAppBarPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
              // Action de la maison
            },
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 61, 14, 214),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage(token: token)),
              );
            },
          ),
        ],
      ),
    );
  }
}
