import 'dart:convert';

import 'package:clone_spotify_mars/models/user_model.dart';

List<PortGarageModel> portGarageModelFromJson(String str) =>
    List<PortGarageModel>.from(
      json.decode(str).map((x) => PortGarageModel.fromJson(x)),
    );

String portGarageModelToJson(List<PortGarageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

 
class PortGarageModel {
  String id;
  bool portGarage;
  UserModel client;

  PortGarageModel({
    required this.id,
    required this.portGarage,
    required this.client,
  });

  factory PortGarageModel.fromJson(Map<String, dynamic> json) =>
      PortGarageModel(
        id: json["_id"],
        portGarage: json["portGarage"],
        client: UserModel.fromJson(json["client"]),
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "portGarage": portGarage,
    "client": client.toJson(),
  };
}
