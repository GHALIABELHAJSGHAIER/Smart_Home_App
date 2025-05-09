import 'dart:convert';

import 'package:clone_spotify_mars/models/espace_model.dart';

List<WcModel> wcModelFromJson(String str) =>
    List<WcModel>.from(json.decode(str).map((x) => WcModel.fromJson(x)));

String wcModelToJson(List<WcModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WcModel {
  String id;
  bool relaySolarHeat;
  bool relayHeat;
  double temperature;
  int humidity;
  EspaceModel espace;

  WcModel({
    required this.id,
    required this.relaySolarHeat,
    required this.relayHeat,
    required this.temperature,
    required this.humidity,
    required this.espace,
  });

  factory WcModel.fromJson(Map<String, dynamic> json) => WcModel(
    id: json["_id"],
    relaySolarHeat: json["relaySolarHeat"],
    relayHeat: json["relayHeat"],
    temperature: json["temperature"]?.toDouble(),
    humidity: json["humidity"],
    espace: EspaceModel.fromJson(json["espace"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "relaySolarHeat": relaySolarHeat,
    "relayHeat": relayHeat,
    "temperature": temperature,
    "humidity": humidity,
    "espace": espace.toJson(),
  };
}
