import 'dart:convert';

import 'package:clone_spotify_mars/models/Maison/portGarage_model.dart';
import 'package:clone_spotify_mars/models/user_model.dart';

List<HistoriqueGarageModel> historiqueGarageModelFromJson(String str) =>
    List<HistoriqueGarageModel>.from(
      json.decode(str).map((x) => HistoriqueGarageModel.fromJson(x)),
    );

String historiqueGarageModelToJson(List<HistoriqueGarageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// EspaceModel espace;
//espace: EspaceModel.fromJson(
//json["espace"],
// ),
//"espace": espace.toJson(),
class HistoriqueGarageModel {
  String id;
  bool etat;
  DateTime date;
  PortGarageModel garage;
  UserModel client;

  HistoriqueGarageModel({
    required this.id,
    required this.etat,
    required this.date,
    required this.garage,
    required this.client,
  });

  factory HistoriqueGarageModel.fromJson(Map<String, dynamic> json) {
    return HistoriqueGarageModel(
      id: json["_id"],
      etat: json["etat"],
      date: DateTime.parse(json["date"]),
      garage: PortGarageModel.fromJson(json["portGarage"]),
      client: UserModel.fromJson(json["client"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "etat": etat,
    "date": date.toIso8601String(),
    "garage": garage.toJson(),
    "client": client.toJson(),
  };
}
