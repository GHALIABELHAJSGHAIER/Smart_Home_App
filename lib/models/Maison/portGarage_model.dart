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
  final String clientId;

  PortGarageModel({
    required this.id,
    required this.portGarage, // Maintenant modifiable
    required this.clientId,
  });

  factory PortGarageModel.fromJson(Map<String, dynamic> json) {
    return PortGarageModel(
      id: json["_id"] ?? '',
      portGarage: json["portGarage"] ?? false,
      clientId:
          json["client"] is String
              ? json["client"]
              : json["client"]?["_id"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "portGarage": portGarage,
    "client": clientId,
  };
}
