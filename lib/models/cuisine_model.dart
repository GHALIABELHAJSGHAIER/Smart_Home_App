 
import 'dart:convert';

import 'package:clone_spotify_mars/models/espace_model.dart';

List<CuisineModel> cuisineModelFromJson(String str) => List<CuisineModel>.from(
  json.decode(str).map((x) => CuisineModel.fromJson(x)),
);

String cuisineModelToJson(List<CuisineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CuisineModel {
  String id; // l'ID du document dans la base de données (MongoDB)
  bool relayInc;
  double flamme;
  double gaz;
  EspaceModel espace; // Le champ "espace" doit être un objet EspaceModel

  CuisineModel({
    required this.id,
    required this.relayInc,
    required this.flamme,
    required this.gaz,
    required this.espace,
  });

  factory CuisineModel.fromJson(Map<String, dynamic> json) => CuisineModel(
    id: json["_id"], // Ici, '_id' est une chaîne de caractères directement
    relayInc: json["relayInc"],
    flamme: json["flamme"].toDouble(),
    gaz: json["gaz"].toDouble(),
    espace: EspaceModel.fromJson(
      json["espace"],
    ), // 'espace' devient un objet EspaceModel
  );

  Map<String, dynamic> toJson() => {
    "_id": id, // retourne l'ID dans la structure de MongoDB
    "relayInc": relayInc,
    "flamme": flamme,
    "gaz": gaz,
    "espace": espace.toJson(), // Convertit l'objet EspaceModel en JSON
  };
}
