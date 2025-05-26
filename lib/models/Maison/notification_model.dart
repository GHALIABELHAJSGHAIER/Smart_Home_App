import 'dart:convert';

// Convertir une liste JSON en liste d'objets NotificationModel
List<NotificationModel> notificationModelFromJson(String str) =>
    List<NotificationModel>.from(
      json.decode(str).map((x) => NotificationModel.fromJson(x)),
    );

// Convertir une liste d'objets notificationModel en JSON
String notificationToJson(List<NotificationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
  final String id;
  final String alarmeId;
  final String notifMsg;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.alarmeId,
    required this.notifMsg,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["_id"] ?? '',
      alarmeId: json["alarmeId"] ?? '',
      notifMsg: json["notif_msg"] ?? '',
      date: DateTime.parse(json["date"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "alarmeId": alarmeId,
    "notif_msg": notifMsg,
    "date": date.toIso8601String(),
  };
}
