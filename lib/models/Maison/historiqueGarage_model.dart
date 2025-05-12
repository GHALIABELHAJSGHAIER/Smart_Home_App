import 'dart:convert';
//import 'package:clone_spotify_mars/models/Maison/portGarage_model.dart';

List<HistoriqueGarageModel> historiqueGarageModelFromJson(String str) =>
    List<HistoriqueGarageModel>.from(
      json.decode(str).map((x) => HistoriqueGarageModel.fromJson(x)),
    );

String historiqueGarageModelToJson(List<HistoriqueGarageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class HistoriqueGarageModel {
//   String id;
//   bool etat;
//   DateTime date;
//   PortGarageModel garage;

//   HistoriqueGarageModel({
//     required this.id,
//     required this.etat,
//     required this.date,
//     required this.garage,
//   });

// factory HistoriqueGarageModel.fromJson(Map<String, dynamic> json) {
//   return HistoriqueGarageModel(
//     id: json["_id"],
//     etat: json["etat"] ?? false, // Fournir une valeur par défaut si null
//     date: DateTime.parse(json["date"]),
//     garage: PortGarageModel.fromJson(json["garage"]),
//   );
// }

//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "etat": etat,
//     "date": date.toIso8601String(),
//     "garage": garage.toJson(),
//   };
// }
class HistoriqueGarageModel {
  final String id;
  final bool etat;
  final DateTime date;
  final String garageId; // Simplifié à l'ID seulement

  HistoriqueGarageModel({
    required this.id,
    required this.etat,
    required this.date,
    required this.garageId,
  });

  factory HistoriqueGarageModel.fromJson(Map<String, dynamic> json) {
    return HistoriqueGarageModel(
      id: json["_id"] ?? '',
      etat: json["etat"] ?? false,
      date: DateTime.parse(json["date"] ?? DateTime.now().toString()),
      garageId:
          json["garage"] is String
              ? json["garage"]
              : json["garage"]?["_id"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "etat": etat,
    "date": date.toIso8601String(),
    "garage": garageId,
  };
}
