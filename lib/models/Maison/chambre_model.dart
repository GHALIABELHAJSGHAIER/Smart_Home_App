import 'dart:convert';

import 'package:clone_spotify_mars/models/espace_model.dart';

List<ChambreModel> chambreModelFromJson(String str) => List<ChambreModel>.from(
  json.decode(str).map((x) => ChambreModel.fromJson(x)),
);

String chambreModelToJson(List<ChambreModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChambreModel {
  String id;
  bool relayClimChambre;
  bool relayLamp;
  bool relayOpenWindow;
  bool relayCloseWindow;
  double tempChambre;
  int humChambre;
  EspaceModel espace;

  ChambreModel({
    required this.id,
    required this.relayClimChambre,
    required this.relayLamp,
    required this.relayOpenWindow,
    required this.relayCloseWindow,
    required this.tempChambre,
    required this.humChambre,
    required this.espace,
  });

  factory ChambreModel.fromJson(Map<String, dynamic> json) => ChambreModel(
    id: json["_id"],
    relayClimChambre: json["relayClimChambre"],
    relayLamp: json["relayLamp"],
    relayOpenWindow: json["relayOpenWindow"],
    relayCloseWindow: json["relayCloseWindow"],
    tempChambre: json["tempChambre"]?.toDouble(),
    humChambre: json["humChambre"],
    espace: EspaceModel.fromJson(json["espace"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "relayClimChambre": relayClimChambre,
    "relayLamp": relayLamp,
    "relayOpenWindow": relayOpenWindow,
    "relayCloseWindow": relayCloseWindow,
    "tempChambre": tempChambre,
    "humChambre": humChambre,
    "espace": espace.toJson(),
  };
}
