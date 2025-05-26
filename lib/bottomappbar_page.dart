import 'package:clone_spotify_mars/screens/home_page.dart';
import 'package:flutter/material.dart';
import '../screens/profile_page.dart';

class BottomAppBarPage extends StatefulWidget {
  final String token;

  const BottomAppBarPage({super.key, required this.token});

  @override
  _BottomAppBarPageState createState() => _BottomAppBarPageState();
}

class _BottomAppBarPageState extends State<BottomAppBarPage> {
  int _selectedIndex = 0;

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(token: widget.token)),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProfilePage(token: widget.token)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 61, 14, 214);

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 0 ? primaryColor : Colors.grey,
            ),
            onPressed: () => _navigateTo(0),
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: Icon(
              Icons.person,
              color: _selectedIndex == 1 ? primaryColor : Colors.grey,
            ),
            onPressed: () => _navigateTo(1),
          ),
        ],
      ),
    );
  }
}
