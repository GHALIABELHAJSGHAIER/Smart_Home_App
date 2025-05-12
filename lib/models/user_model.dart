import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  String? username;
  String? email;
  String? password;

  UserModel({this.username, this.email, this.password});

  Map<String, dynamic> toJson() {
    return {"username": username, "email": email, "password": password};
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json["username"],
    email: json["email"],
    password: json["password"],
  );
}
