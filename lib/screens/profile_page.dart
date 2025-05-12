import 'package:clone_spotify_mars/controllers/auth_controller.dart';
import 'package:clone_spotify_mars/models/user_model.dart';
import 'package:clone_spotify_mars/screens/Maison/pagePortGarage.dart';
import 'package:clone_spotify_mars/screens/gemini_page.dart';

import 'package:clone_spotify_mars/screens/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.token});
  final String token;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String clientId;
  late SharedPreferences prefs;
  final controller = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    final jwtDecodedToken = JwtDecoder.decode(widget.token);
    clientId = jwtDecodedToken['id'];
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Mon Profil',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Section Avatar
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue.shade100, width: 3),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/placeholder_profile.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 30, 146, 12),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Ajouter la logique d'édition ici
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Section Informations
            FutureBuilder<List<UserModel>>(
              future: controller.getUserById(clientId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erreur de chargement: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Aucune donnée utilisateur trouvée'),
                  );
                }

                final user = snapshot.data!.first;
                return Column(
                  children: [
                    _buildInfoCard(
                      title: 'Informations Personnelles',
                      items: [
                        _buildInfoItem(
                          icon: Icons.person_outline,
                          label: 'Nom d\'utilisateur',
                          value: ("${user.username}"),
                        ),
                        _buildInfoItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: ("${user.email}"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoCard(
                      title: 'Statistiques',
                      items: [
                        // Exemple à compléter selon les données disponibles
                        // _buildInfoItem(
                        //   icon: Icons.home_outlined,
                        //   label: 'Maisons',
                        //   value: user.maisons.length.toString(),
                        // ),
                      ],
                    ),
                  ],
                );
              },
            ),

            // Boutons d'action
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.key_outlined,
                    label: 'Porte',
                    color: Colors.green,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PortGaragePage(clientId: clientId),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.logout_outlined,
                    label: 'Déconnexion',
                    color: Colors.red,
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GeminiPage()),
          );
        },
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.chat_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> items}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const Divider(height: 20),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue.shade600),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
