import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../screens/signin_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _telephoneController;
  late GlobalKey<FormState> _formkey;
  final controller = Get.put(AuthController());
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _telephoneController = TextEditingController();
    _formkey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telephoneController.dispose();
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
            "S'inscrire",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Image.asset("assets/logo_text.png")),
                    Center(
                      child: Text(
                        "Créez un compte une fois et connectez-vous à tous nos services.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w400,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Username
                    Text(
                      "Username",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 76, 76, 76),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: "Username",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      validator: RequiredValidator(
                        errorText: "username is required",
                      ),
                    ),
                    SizedBox(height: 10),

                    // Telephone
                    Text(
                      "Téléphone",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _telephoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 76, 76, 76),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: "Téléphone",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: Colors.white,
                        ),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      validator: MultiValidator([
                        RequiredValidator(errorText: "telephone is required"),
                        PatternValidator(
                          r'^[0-9]+$',
                          errorText: 'only numbers are allowed',
                        ),
                        MinLengthValidator(8, errorText: 'min 8 digits'),
                        MaxLengthValidator(15, errorText: 'max 15 digits'),
                      ]),
                    ),
                    SizedBox(height: 10),
                    // Email
                    Text(
                      "Email",
                      style: TextStyle(
                        color: Colors.black,
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
                        labelText: "Email",
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
                      validator: MultiValidator([
                        EmailValidator(
                          errorText: 'enter a valid email address',
                        ),
                        RequiredValidator(errorText: "email is required"),
                      ]),
                    ),
                    SizedBox(height: 10),

                    // Password
                    Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.black,
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
                        labelText: "Password",
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
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'password is required'),
                        MinLengthValidator(
                          8,
                          errorText: 'password must be at least 8 digits long',
                        ),
                        MaxLengthValidator(
                          15,
                          errorText: 'password must be at most 15 digits long',
                        ),
                      ]),
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
                                  username: _usernameController.text,
                                  email: _emailController.text,
                                  telephone: _telephoneController.text,
                                  password: _passwordController.text,
                                );
                                var result = await controller.signupController(
                                  user,
                                );

                                if (result['status'] == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result['success'])),
                                  );
                                  // Optionnel : revenir à la page login ou autre
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result['error'])),
                                  );
                                }
                              }
                            },
                            child: Text(
                              "S'inscrire",
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
                                  builder: (context) => const SigninPage(),
                                ),
                              );
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Colors.white),
                                children: const <TextSpan>[
                                  TextSpan(text: "Avez-vous un compte ?  "),
                                  TextSpan(
                                    text: "Se connecter",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 156, 187, 201),
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
    );
  }
}
