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

  Future<Map<String, dynamic>> deleteUserById(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          "http://192.168.100.106:5000/users/deleteUser/$id",
        ), // Replace with your actual delete endpoint
        headers: {"Content-Type": "application/json"},
      );

      //final response = await http.get(Uri.parse('$deleteuser/$id'));

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['status'] == true) {
        return {
          "status": true,
          "message":
              jsonResponse['message'] ?? "Utilisateur supprimé avec succès",
        };
      } else {
        return {
          "status": false,
          "error":
              jsonResponse['message'] ??
              "Échec de la suppression de l'utilisateur",
        };
      }
    } catch (e) {
      return {
        "status": false,
        "error":
            "Erreur lors de la suppression de l'utilisateur : ${e.toString()}",
      };
    }
  }

  Future<Map<String, dynamic>> updateUserById(String id, UserModel user) async {
    try {
      // Vérifier qu'au moins un champ est fourni pour la mise à jour
      if ((user.email == null || user.email!.isEmpty) &&
          (user.username == null || user.username!.isEmpty) &&
          (user.telephone == null || user.telephone!.isEmpty)) {
        return {"status": false, "error": "Aucune donnée à mettre à jour."};
      }

      // Construire les données à mettre à jour uniquement avec les champs non vides
      final Map<String, dynamic> updateData = {};
      if (user.email != null && user.email!.isNotEmpty) {
        updateData['email'] = user.email;
      }
      if (user.username != null && user.username!.isNotEmpty) {
        updateData['username'] = user.username;
      }
      if (user.telephone != null && user.telephone!.isNotEmpty) {
        updateData['telephone'] = user.telephone;
      }

      final response = await http.put(
        Uri.parse("http://192.168.100.106:5000/users/updateUserById/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updateData),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonResponse.containsKey('updated')) {
          return {
            "status": true,
            "success": "Utilisateur mis à jour avec succès.",
            "updatedUser": UserModel.fromJson(jsonResponse['updated']),
          };
        } else {
          return {
            "status": false,
            "error":
                "Réponse inattendue du serveur: utilisateur mis à jour non retourné.",
          };
        }
      } else {
        return {
          "status": false,
          "error": jsonResponse['message'] ?? "Échec de la mise à jour",
        };
      }
    } catch (error) {
      return {"status": false, "error": error.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePassword(
    String id,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("http://192.168.100.106:5000/users/updatePassword/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "status": true,
          "message":
              jsonResponse['message'] ?? "Mot de passe mis à jour avec succès",
        };
      } else if (response.statusCode == 400 &&
          jsonResponse['message'] == "Mot de passe actuel incorrect") {
        return {"status": false, "error": "Mot de passe actuel incorrect"};
      } else {
        return {
          "status": false,
          "error":
              jsonResponse['message'] ??
              "Échec de la mise à jour du mot de passe",
        };
      }
    } catch (e) {
      return {"status": false, "error": "Erreur de connexion: ${e.toString()}"};
    }
  }
}
