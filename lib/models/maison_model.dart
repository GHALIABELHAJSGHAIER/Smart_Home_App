import 'dart:convert';

List<MaisonModel> maisonModelFromJson(String str) => List<MaisonModel>.from(
  json.decode(str).map((x) => MaisonModel.fromJson(x)),
);

String maisonModelToJson(List<MaisonModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MaisonModel {
  String id;
  String? clientId;
  String? name;
  String? address;
  String? numCartEsp;

  MaisonModel({required this.id, this.clientId, this.name, this.address, this.numCartEsp});

  Map<String, dynamic> toJson() {
    return {"id": id, "clientId": clientId, "name": name, "address": address, "numCartEsp": numCartEsp};
  }

  factory MaisonModel.fromJson(Map<String, dynamic> json) => MaisonModel(
    id: json["_id"],
    clientId: json["clientId"],
    name: json["name"],
    address: json["address"],
    numCartEsp: json["numCartEsp"],
  );
}
