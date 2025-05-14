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
  double tempWC;
  int humWC;
  EspaceModel espace;

  WcModel({
    required this.id,
    required this.relaySolarHeat,
    required this.relayHeat,
    required this.tempWC,
    required this.humWC,
    required this.espace,
  });

  factory WcModel.fromJson(Map<String, dynamic> json) => WcModel(
    id: json["_id"],
    relaySolarHeat: json["relaySolarHeat"],
    relayHeat: json["relayHeat"],
    tempWC: json["tempWC"]?.toDouble(),
    humWC: json["humWC"],
    espace: EspaceModel.fromJson(json["espace"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "relaySolarHeat": relaySolarHeat,
    "relayHeat": relayHeat,
    "tempWC": tempWC,
    "humWC": humWC,
    "espace": espace.toJson(),
  };
}
