import 'dart:convert';

import 'package:clone_spotify_mars/models/todo_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/todo_model.dart';

class TodoController extends GetxController {
  static TodoController get instance => Get.find();

  // create new todo : http://localhost:5000/todo/storeTodo
  // body : {
  //     "userId":"67dbb4427778831a29b20027",
  //     "title":"this is  2",
  //     "desc":"this is my second todo"
  // }
  Future<Map<String, dynamic>> createTodo(TodoModel todo) async {
    var response = await http.post(
      Uri.parse(storeTodo),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(todo.toJson()),
    );

    var jsonResponse = jsonDecode(response.body);

    if (jsonResponse['status'] == true) {
      return {"status": true, "success": "Todo Registered Successfully"};
    } else {
      return {
        "status": false,
        "error": jsonResponse['message'] ?? "Todo Failed",
      };
    }
  }

  // Get todo list : "http://localhost:5000/todo/getUserTodoList/{user id}"
  Future<List<TodoModel>> getTodoList(String userId) async {
    var response = await http.get(
      Uri.parse('$getTodo/$userId'),
      headers: {"Content-Type": "application/json"},
    );

    try {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        return (jsonResponse['success'] as List)
            .map((todo) => TodoModel.fromJson(todo))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //Delete todo : http://localhost:5000/todo/deleteTodo/{id Todo}
  Future<bool> deleteTodo(String id) async {
    var response = await http.delete(
      Uri.parse('$deleteTodoItem/$id'),
      headers: {"Content-Type": "application/json"},
    );
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse['status'];
  }
}
