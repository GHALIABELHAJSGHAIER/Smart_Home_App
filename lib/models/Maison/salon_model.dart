import 'dart:convert';

import 'package:clone_spotify_mars/models/espace_model.dart';

List<SalonModel> salonModelFromJson(String str) =>
    List<SalonModel>.from(json.decode(str).map((x) => SalonModel.fromJson(x)));

String salonModelToJson(List<SalonModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

 
class SalonModel {
  String id;
  bool relayOpenWindow;
  bool relayClim;
  bool relayCloseWindow;
  double temperature;
  int humidity;
  EspaceModel espace;

  SalonModel({
    required this.id,
    required this.relayOpenWindow,
    required this.relayClim,
    required this.relayCloseWindow,
    required this.temperature,
    required this.humidity,
    required this.espace,
  });

  factory SalonModel.fromJson(Map<String, dynamic> json) => SalonModel(
    id: json["_id"],
    relayOpenWindow: json["relayOpenWindow"],
    relayClim: json["relayClim"],
    relayCloseWindow: json["relayCloseWindow"],
    temperature: json["temperature"]?.toDouble(),
    humidity: json["humidity"],
    espace: EspaceModel.fromJson(json["espace"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "relayOpenWindow": relayOpenWindow,
    "relayClim": relayClim,
    "relayCloseWindow": relayCloseWindow,
    "temperature": temperature,
    "humidity": humidity,
    "espace": espace.toJson(),
  };
}
