import 'dart:convert';

import 'package:clone_spotify_mars/models/espace_model.dart';

List<ChambreModel> chambreModelFromJson(String str) => List<ChambreModel>.from(
  json.decode(str).map((x) => ChambreModel.fromJson(x)),
);

String chambreModelToJson(List<ChambreModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChambreModel {
  String id;
  bool relayClim;
  bool relayLamp;
  bool relayOpenWindow;
  bool relayCloseWindow;
  double temperature;
  int humidity;
  EspaceModel espace;

  ChambreModel({
    required this.id,
    required this.relayClim,
    required this.relayLamp,
    required this.relayOpenWindow,
    required this.relayCloseWindow,
    required this.temperature,
    required this.humidity,
    required this.espace,
  });

  factory ChambreModel.fromJson(Map<String, dynamic> json) => ChambreModel(
    id: json["_id"],
    relayClim: json["relayClim"],
    relayLamp: json["relayLamp"],
    relayOpenWindow: json["relayOpenWindow"],
    relayCloseWindow: json["relayCloseWindow"],
    temperature: json["temperature"]?.toDouble(),
    humidity: json["humidity"],
    espace: EspaceModel.fromJson(json["espace"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "relayClim": relayClim,
    "relayLamp": relayLamp,
    "relayOpenWindow": relayOpenWindow,
    "relayCloseWindow": relayCloseWindow,
    "temperature": temperature,
    "humidity": humidity,
    "espace": espace.toJson(),
  };
}
