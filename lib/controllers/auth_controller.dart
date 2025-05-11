import 'dart:convert';
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
        "success": "User connecter Successfully",
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
    // Ajoutez cette ligne pour vérifier que username n'est pas vide

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

  Future<List<UserModel>> getUserById(String id) async {
    try {
      final response = await http.get(Uri.parse('$getuserbyid/$id'));

      print("Réponse du backend : ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // Modification ici - la réponse contient un objet 'user' et non 'success'
        if (jsonResponse['user'] != null) {
          // Retourne une liste avec un seul utilisateur
          return [UserModel.fromJson(jsonResponse['user'])];
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> updateUserById(
    String id,
    UserModel updatedUser,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          '$updateUserById/$id',
        ), // Assure-toi que cette URL correspond à ta route
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": updatedUser.email,
          "username": updatedUser.username,
        }),
      );

      print("Réponse du backend (update) : ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return {
          "status": true,
          "updated": UserModel.fromJson(jsonResponse['updated']),
        };
      } else {
        final jsonResponse = jsonDecode(response.body);
        return {
          "status": false,
          "error": jsonResponse['message'] ?? "Erreur lors de la mise à jour",
        };
      }
    } catch (e) {
      return {"status": false, "error": "Exception: ${e.toString()}"};
    }
  }
}
