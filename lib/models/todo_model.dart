import 'dart:convert';

List<TodoModel> todoModelFromJson(String str) =>
    List<TodoModel>.from(json.decode(str).map((x) => TodoModel.fromJson(x)));

String todoModelToJson(List<TodoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TodoModel {
  String? id;
  String? userId;
  String? title;
  String? desc;

  TodoModel({this.id, this.userId, this.title, this.desc});

  Map<String, dynamic> toJson() {
    return {"id": id, "userId": userId, "title": title, "desc": desc};
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
    id: json["_id"],
    userId: json["userId"],
    title: json["title"],
    desc: json["desc"],
  );
}
