import 'dart:convert';

//import 'package:clone_spotify_mars/models/user_model.dart';

List<PortGarageModel> portGarageModelFromJson(String str) =>
    List<PortGarageModel>.from(
      json.decode(str).map((x) => PortGarageModel.fromJson(x)),
    );

String portGarageModelToJson(List<PortGarageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PortGarageModel {
  final String id;
  bool portGarage; // Changé de final à mutable
  final String maisonId;

  PortGarageModel({
    required this.id,
    required this.portGarage, // Maintenant modifiable
    required this.maisonId,
  });

  factory PortGarageModel.fromJson(Map<String, dynamic> json) {
    return PortGarageModel(
      id: json["_id"] ?? '',
      portGarage: json["portGarage"] ?? false,
      maisonId: json["maisonId"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "portGarage": portGarage,
    "maison": maisonId,
  };
}
