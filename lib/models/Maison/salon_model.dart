import 'dart:convert';

import 'package:clone_spotify_mars/models/espace_model.dart';

List<SalonModel> salonModelFromJson(String str) =>
    List<SalonModel>.from(json.decode(str).map((x) => SalonModel.fromJson(x)));

String salonModelToJson(List<SalonModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalonModel {
  String id;
  bool relayOpenWindowSalon;
  bool relayClimSalon;
  bool relayCloseWindowSalon;
  double tempSalon;
  int humSalon;
  EspaceModel espace;

  SalonModel({
    required this.id,
    required this.relayOpenWindowSalon,
    required this.relayClimSalon,
    required this.relayCloseWindowSalon,
    required this.tempSalon,
    required this.humSalon,
    required this.espace,
  });

  factory SalonModel.fromJson(Map<String, dynamic> json) => SalonModel(
    id: json["_id"],
    relayOpenWindowSalon: json["relayOpenWindowSalon"],
    relayClimSalon: json["relayClimSalon"],
    relayCloseWindowSalon: json["relayCloseWindowSalon"],
    tempSalon: json["tempSalon"]?.toDouble(),
    humSalon: json["humSalon"],
    espace: EspaceModel.fromJson(json["espace"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "relayOpenWindowSalon": relayOpenWindowSalon,
    "relayClimSalon": relayClimSalon,
    "relayCloseWindowSalon": relayCloseWindowSalon,
    "tempSalon": tempSalon,
    "humSalon": humSalon,
    "espace": espace.toJson(),
  };
}
