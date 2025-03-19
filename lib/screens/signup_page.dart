import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  File? _image;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Aucune image sélectionnée")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la sélection de l'image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5E6D3), // Beige clair
        appBar: AppBar(
          foregroundColor: Colors.brown.shade800,
          backgroundColor: const Color(0xFFF5E6D3), // Marron clair
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.brown.shade300, // Marron doux
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                        child:
                            _image == null
                                ? const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 40,
                                )
                                : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel("Username"),
                  _buildTextField(
                    controller: _usernameController,
                    label: "Username",
                    icon: Icons.person,
                    validator: RequiredValidator(
                      errorText: "Username is required",
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildLabel("Email"),
                  _buildTextField(
                    controller: _emailController,
                    label: "Email",
                    icon: Icons.email_outlined,
                    validator: MultiValidator([
                      EmailValidator(errorText: 'Enter a valid email address'),
                      RequiredValidator(errorText: "Email is required"),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  _buildLabel("Password"),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      color: const Color(0xFF8B5E3B), // Beige foncé
                      borderRadius: BorderRadius.circular(20),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Signup Success")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Signup Failed")),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.brown,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: Colors.brown.shade100, // Beige doux pour le champ
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.brown, fontSize: 18),
        prefixIcon: Icon(icon, color: Colors.brown),
      ),
      style: const TextStyle(color: Colors.brown, fontSize: 18),
      validator: validator,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _isObscure,
      decoration: InputDecoration(
        fillColor: Colors.brown.shade100, // Beige doux pour le champ
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        labelText: "Password",
        labelStyle: const TextStyle(color: Colors.brown, fontSize: 18),
        prefixIcon: const Icon(Icons.lock, color: Colors.brown),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          icon: Icon(
            _isObscure ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
            color: Colors.brown,
          ),
        ),
      ),
      style: const TextStyle(color: Colors.brown, fontSize: 18),
      validator: MultiValidator([
        RequiredValidator(errorText: 'Password is required'),
        MinLengthValidator(
          8,
          errorText: 'Password must be at least 8 characters',
        ),
      ]),
    );
  }
}
