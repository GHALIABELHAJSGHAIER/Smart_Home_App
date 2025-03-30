import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:clone_spotify_mars/screens/files_page.dart';
//import 'package:clone_spotify_mars/screens/routes_folder/biblio_page.dart';
import '../screens/home_page.dart';
//import 'package:clone_spotify_mars/screens/routes_folder/profile_page.dart';
//import 'package:clone_spotify_mars/screens/routes_folder/search_page.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  List<Widget> _screens = [
    HomePage(token: '',),
    HomePage(token: '',),
    //SearchPage(),
    //BiblioPage(),
    //ProfilePage(),
  ];

  List<String> _titles = ["Home", "Search", "Biblio", "Profile"];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _titles[_selectedIndex],
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFA67B5B)),
              accountName: Text(
                "Yahya chebbi",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                "yahya.ch.chebbi@gmail.com",
                style: GoogleFonts.poppins(),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/images/person_image.jpeg"),
              ),
            ),
            _buildDrawerItem(Icons.file_copy_rounded, "My Files", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(token: '',)),
              );
            }),
            _buildDrawerItem(Icons.person, "Change profile", () {}),
            _buildDrawerItem(Icons.download, "Download", () {}),
            _buildDrawerItem(Icons.settings, "Settings", () {}),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFA67B5B),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.poppins(),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_rounded),
            label: "Biblio",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
      onTap: onTap,
    );
  }
}
