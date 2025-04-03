import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../config.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  Future<Map<String, dynamic>> signinController(UserModel user) async {
    var reqBody = {"email": user.email, "password": user.password};

    var response = await http.post(
      Uri.parse(login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == true) {
      var myToken = jsonResponse['token'];
      return {
        "status": true,
        "success": "User Registered Successfully",
        "token": myToken,
      };
    } else {
      return {
        "status": false,
        "error": jsonResponse['message'] ?? "Registration Failed",
      };
    }
  }

  Future<Map<String, dynamic>> signupController(UserModel user) async {
    print(
      "Username: ${user.username}",
    ); // Ajoutez cette ligne pour vérifier que username n'est pas vide

    var response = await http.post(
      Uri.parse(register),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == true) {
      // Sauvegarder les informations dans SharedPreferences après une inscription réussie
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'username',
        user.username ?? '',
      ); // Sauvegarder le username
      await prefs.setString('email', user.email ?? '');
      await prefs.setString(
        'password',
        user.password ?? '',
      ); // Il est préférable d'éviter de stocker le mot de passe pour des raisons de sécurité
      print('Username stored: ${user.username}'); // Affichez ce qui est stocké
      return {"status": true, "success": "User Registered Successfully"};
    } else {
      return {
        "status": false,
        "error": jsonResponse['message'] ?? "Registration Failed",
      };
    }
  }
}
