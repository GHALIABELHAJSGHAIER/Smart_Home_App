import 'package:clone_spotify_mars/screens/ajouter_Maison_page.dart';
import 'package:clone_spotify_mars/screens/routes_page.dart';
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //return MaterialApp(title: 'Spotify', home: LoginPage());
    //return MaterialApp(title: 'Smart Home', home: HomeScreen());
    //return MaterialApp(title: 'Smart Home', home: WelcomePage());
    return MaterialApp(title: 'Spotify', home: RoutesPage());
    //return MaterialApp(title: 'Spotify', home: AjouterMaisonPage());
  }
}
