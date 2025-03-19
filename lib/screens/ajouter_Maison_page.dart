import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AjouterMaisonPage extends StatefulWidget {
  @override
  _AjouterMaisonPageState createState() => _AjouterMaisonPageState();
}

class _AjouterMaisonPageState extends State<AjouterMaisonPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  XFile? _image;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Initialisation de l'animation
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward(); // Démarre l'animation
  }

  // Sélection de l'image
  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  // Ajouter une maison avec validation
  void _ajouterMaison() {
    if (_formKey.currentState!.validate()) {
      final nomMaison = _nomController.text;
      final adresseMaison = _adresseController.text;
      print(
        "Maison ajoutée : $nomMaison, $adresseMaison, Image: ${_image?.path}",
      );

      // Réinitialiser les champs après l'ajout
      _nomController.clear();
      _adresseController.clear();
      setState(() {
        _image = null;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Maison ajoutée avec succès !')));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Ajouter une Maison'))),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          // Utilisation du SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ pour le nom de la maison
                  _buildTextField(
                    controller: _nomController,
                    label: 'Nom de la Maison',
                    icon: Icons.house,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le nom de la maison';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Champ pour l'adresse de la maison
                  _buildTextField(
                    controller: _adresseController,
                    label: 'Adresse de la Maison',
                    icon: Icons.location_on,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer l\'adresse de la maison';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Sélection de l'image avec animation
                  _image == null
                      ? GestureDetector(
                        onTap: _selectImage,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, color: Colors.grey),
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  'Sélectionner une image',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : kIsWeb
                      ? Image.network(
                        _image!.path,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ) // Pour le Web
                      : Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            child: Image.file(
                              File(_image!.path),
                              height: 150, // Limite la taille de l'image
                              width: 150, // Limite la taille de l'image
                              fit: BoxFit.cover,
                            ),
                          ),
                          TextButton(
                            onPressed: _selectImage,
                            child: Text('Changer l\'image'),
                          ),
                        ],
                      ),
                  SizedBox(height: 20),

                  // Bouton pour ajouter la maison
                  AnimatedButton(
                    onPressed: _ajouterMaison,
                    label: 'Ajouter la Maison',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget pour les champs de texte avec validation
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }
}

// Widget de bouton animé
class AnimatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  AnimatedButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA67B5B),
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
