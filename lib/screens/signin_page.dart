import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../screens/home_page.dart';
import '../screens/signup_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formkey;
  bool _isObscure = true;

  final controller = Get.put(AuthController());
  late SharedPreferences prefs;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formkey = GlobalKey<FormState>();
    initSharedPref();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            "Se connecter",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/maison.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Image.asset("assets/logo_text.png")),

                      Center(
                        child: Text(
                          "Créez un compte une fois et connectez-vous à tous nos services",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.w400,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Email ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 76, 76, 76),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: "Email ",
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                          ),
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        validator:
                            MultiValidator([
                              EmailValidator(
                                errorText: 'enter a valid email address',
                              ),
                              RequiredValidator(errorText: "email is required"),
                            ]).call,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 76, 76, 76),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelText: "password",
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(
                              _isObscure
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        validator:
                            MultiValidator([
                              RequiredValidator(
                                errorText: 'password is required',
                              ),
                              MinLengthValidator(
                                8,
                                errorText:
                                    'password must be at least 8 digits long',
                              ),
                              MaxLengthValidator(
                                15,
                                errorText:
                                    'password must be at least 15 digits long',
                              ),
                            ]).call,
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CupertinoButton(
                              color: const Color.fromARGB(255, 156, 187, 201),
                              borderRadius: BorderRadius.circular(20),
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  final user = UserModel(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  var result = await controller
                                      .signinController(user);
                                  if (result['status'] == true) {
                                    print("response Token: ${result['token']}");
                                    var mytoken = result['token'];
                                    prefs.setString('token', mytoken);
                                    print("Stored Token: $mytoken");
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                HomePage(token: mytoken),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(result['error'])),
                                    );
                                  }
                                  print("success");
                                } else {
                                  print("failure");
                                }
                              },
                              child: Text(
                                "Se connecter",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),

                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupPage(),
                                  ),
                                );
                              },
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall!.copyWith(
                                    color:
                                        Colors
                                            .white, // Appliquer le blanc au texte de base
                                  ),
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: "Vous n'avez pas de compte ? ",
                                    ),
                                    TextSpan(
                                      text: "S'inscrire",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          156,
                                          187,
                                          201,
                                        ),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
