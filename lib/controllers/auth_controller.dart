/*import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
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
    var response = await http.post(
      Uri.parse(register),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == true) {
      return {"status": true, "success": "User Registered Successfully"};
    } else {
      return {
        "status": false,
        "error": jsonResponse['message'] ?? "Registration Failed",
      };
    }
  }
}
*/
////////////2

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      
      // Sauvegarder les informations dans SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', myToken);
      await prefs.setString('username', user.username ?? '');
      await prefs.setString('email', user.email ?? '');
      await prefs.setString('password', user.password ?? ''); // Vous pouvez éviter de stocker le mot de passe si vous ne voulez pas

      return {
        "status": true,
        "success": "User Logged in Successfully",
        "token": myToken,
      };
    } else {
      return {
        "status": false,
        "error": jsonResponse['message'] ?? "Login Failed",
      };
    }
  }

  Future<Map<String, dynamic>> signupController(UserModel user) async {
    var response = await http.post(
      Uri.parse(register),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == true) {
      return {"status": true, "success": "User Registered Successfully"};
    } else {
      return {
        "status": false,
        "error": jsonResponse['message'] ?? "Registration Failed",
      };
    }
  }
}
