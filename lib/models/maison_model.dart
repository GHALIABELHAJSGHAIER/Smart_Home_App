// To parse this JSON data, do
//
//     final maisonModel = maisonModelFromJson(jsonString);

import 'dart:convert';

MaisonModel maisonModelFromJson(String str) => MaisonModel.fromJson(json.decode(str));

String maisonModelToJson(MaisonModel data) => json.encode(data.toJson());

class MaisonModel {
    String id;
    String clientId;
    String name;
    String address;

    MaisonModel({
        required this.id,
        required this.clientId,
        required this.name,
        required this.address,
    });

    factory MaisonModel.fromJson(Map<String, dynamic> json) => MaisonModel(
        id: json["_id"],
        clientId: json["clientId"],
        name: json["name"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "clientId": clientId,
        "name": name,
        "address": address,
    };
}
