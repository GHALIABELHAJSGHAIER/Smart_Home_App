import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  String? username;
  String? email;
  String? password;
  String? telephone;

  UserModel({this.username, this.email, this.telephone, this.password});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "telephone": telephone,
      "password": password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json["username"],
    telephone: json["telephone"],
    email: json["email"],
    password: json["password"],
  );

  get id => null;
}
