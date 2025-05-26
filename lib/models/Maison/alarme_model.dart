import 'dart:convert';

// Convertir une liste JSON en liste d'objets AlarmeModel
List<AlarmeModel> alarmeModelFromJson(String str) => List<AlarmeModel>.from(
  json.decode(str).map((x) => AlarmeModel.fromJson(x)),
);

// Convertir une liste d'objets AlarmeModel en JSON
String alarmeModelToJson(List<AlarmeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AlarmeModel {
  final String id;
  bool etat;
  bool mvm1;
  bool mvm2;
  bool alarmeBuzzzer;
  final String maisonId;

  AlarmeModel({
    required this.id,
    required this.etat,
    required this.mvm1,
    required this.mvm2,
    required this.alarmeBuzzzer,
    required this.maisonId,
  });

  factory AlarmeModel.fromJson(Map<String, dynamic> json) {
    return AlarmeModel(
      id: json["_id"] ?? '',
      etat: json["etat"] ?? false,
      mvm1: json["mvm1"] ?? false,
      mvm2: json["mvm2"] ?? false,
      alarmeBuzzzer: json["alarmeBuzzzer"] ?? false,
      maisonId:
          json["maison"] != null && json["maison"] is Map
              ? json["maison"]["_id"] ?? ''
              : (json["maison"] ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "etat": etat,
    "mvm1": mvm1,
    "mvm2": mvm2,
    "alarmeBuzzzer": alarmeBuzzzer,
    "maison": maisonId,
  };
}
