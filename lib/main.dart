import 'package:clone_spotify_mars/screens/appareil_page.dart';
import 'package:clone_spotify_mars/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/home_page.dart';
//import '../screens/signin_page.dart';
import '../screens/espace_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Home +',
      home:
          token != null && !JwtDecoder.isExpired(token!)
              ? HomePage(token: token!)
              //: AppareilPage(),
              : WelcomeScreen(),
              //: EspacePage(),
    );
  }
}
