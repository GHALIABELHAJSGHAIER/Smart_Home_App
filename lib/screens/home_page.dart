import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import '../screens/signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.token});
  final String token;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(TodoController());
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late SharedPreferences prefs;
  late List<TodoModel> items = [];

  late String email;
  late String userId;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadTodoList() async {
    List<TodoModel> fetchedItems = await controller.getTodoList(userId);
    setState(() {
      items = fetchedItems;
    });
  }

  @override
  initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    userId = jwtDecodedToken['_id'];
    _loadTodoList();
    initSharedPref();

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: Text(
            "Home Page",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout_outlined, color: Colors.black),
              onPressed: () async {
                await prefs.remove('token');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SigninPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/maison2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Center(child: Image.asset("assets/logo_text.png")),
              SizedBox(height: 10),
              items.isEmpty
                  ? const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "No Data \n Add New Task",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : Expanded(
                    child: FutureBuilder<List<TodoModel>>(
                      future: controller.getTodoList(userId),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder:
                                ((context, index) => ListTile(
                                  leading: Image.asset("assets/logo.png"),
                                  title: Text(snapshot.data![index].title!),
                                  subtitle: Text(snapshot.data![index].desc!),
                                  trailing: IconButton(
                                    onPressed: () {
                                      print(
                                        "Delete item ${snapshot.data![index].id!}",
                                      );
                                      controller.deleteTodo(
                                        snapshot.data![index].id!,
                                      );
                                      _loadTodoList();
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                )),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _displayTextInputDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  final todo = TodoModel(
                    userId: userId,
                    title: _titleController.text,
                    desc: _descriptionController.text,
                  );
                  var result = await controller.createTodo(todo);
                  if (result['status'] == true) {
                    _loadTodoList();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(result['error'])));
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }
}
