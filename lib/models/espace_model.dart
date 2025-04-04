import 'dart:convert';

List<EspaceModel> espaceModelFromJson(String str) =>
    List<EspaceModel>.from(json.decode(str).map((x) => EspaceModel.fromJson(x)));

String espaceModelToJson(List<EspaceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EspaceModel {
  String id;
  String maisonId;
  String nom;

  EspaceModel({
    required this.id,
    required this.maisonId,
    required this.nom,
  });

  factory EspaceModel.fromJson(Map<String, dynamic> json) => EspaceModel(
        id: json["_id"],
        maisonId: json["maisonId"],
        nom: json["nom"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "maisonId": maisonId,
        "nom": nom,
      };
}
