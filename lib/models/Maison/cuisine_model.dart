import 'dart:convert';
import 'package:clone_spotify_mars/models/espace_model.dart';

List<CuisineModel> cuisineModelFromJson(String str) => List<CuisineModel>.from(
  json.decode(str).map((x) => CuisineModel.fromJson(x)),
);

String cuisineModelToJson(List<CuisineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CuisineModel {
  String id;
  bool relayInc;
  bool flamme;
  bool gaz;
  EspaceModel espace;

  CuisineModel({
    required this.id,
    required this.relayInc,
    required this.flamme,
    required this.gaz,
    required this.espace,
  });

  factory CuisineModel.fromJson(Map<String, dynamic> json) => CuisineModel(
    id: json["_id"],
    relayInc: json["relayInc"],
    flamme: json["flamme"],
    gaz: json["gaz"],
    espace: EspaceModel.fromJson(json["espace"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "relayInc": relayInc,
    "flamme": flamme,
    "gaz": gaz,
    "espace": espace.toJson(),
  };
}
