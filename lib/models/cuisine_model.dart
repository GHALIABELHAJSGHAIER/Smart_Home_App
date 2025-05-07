// To parse this JSON data, do
//
//     final cuisineModel = cuisineModelFromJson(jsonString);

import 'dart:convert';

List<CuisineModel> cuisineModelFromJson(String str) => List<CuisineModel>.from(
  json.decode(str).map((x) => CuisineModel.fromJson(x)),
);

String cuisineModelToJson(List<CuisineModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CuisineModel {
  String id;
  String espaceId;
  bool relayInc;
  int flamme;
  int gaz;

  CuisineModel({
    required this.id,
    required this.espaceId,
    required this.relayInc,
    required this.flamme,
    required this.gaz,
  });

  factory CuisineModel.fromJson(Map<String, dynamic> json) => CuisineModel(
    id: json["_id"],
    espaceId: json["espaceId"],
    relayInc: json["relayInc"],
    flamme: json["flamme"],
    gaz: json["gaz"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "espaceId": espaceId,
    "relayInc": relayInc,
    "flamme": flamme,
    "gaz": gaz,
  };
}
