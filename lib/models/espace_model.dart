import 'dart:convert';

List<EspaceModel> espaceModelFromJson(String str) => List<EspaceModel>.from(
  json.decode(str).map((x) => EspaceModel.fromJson(x)),
);

String espaceModelToJson(List<EspaceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EspaceModel {
  String id;
  String maisonId;
  String nom;

  // Constructeur
  EspaceModel({required this.id, required this.maisonId, required this.nom});

  // Factory pour créer une instance d'EspaceModel à partir d'un Map JSON
  factory EspaceModel.fromJson(Map<String, dynamic> json) => EspaceModel(
    id: json["_id"] ?? '', // Valeur par défaut si _id est null
    maisonId: json["maisonId"] ?? '', // Valeur par défaut si maisonId est null
    nom: json["nom"] ?? 'Nom inconnu', // Valeur par défaut si nom est null
  );

  // Méthode toJson pour convertir l'objet EspaceModel en JSON
  Map<String, dynamic> toJson() => {
    "_id": id,
    "maisonId": maisonId,
    "nom": nom,
  };
}
