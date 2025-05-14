// import 'package:clone_spotify_mars/controllers/auth_controller.dart';
// import 'package:clone_spotify_mars/models/user_model.dart';
// import 'package:clone_spotify_mars/screens/Maison/pagePortGarage.dart';
// import 'package:clone_spotify_mars/screens/gemini_page.dart';
// import 'package:clone_spotify_mars/screens/signin_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key, required this.token});
//   final String token;

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   late String clientId;
//   late SharedPreferences prefs;
//   final controller = Get.put(AuthController());
//   late TextEditingController _usernameController;
//   late TextEditingController _emailController;

//   @override
//   void initState() {
//     super.initState();
//     final jwtDecodedToken = JwtDecoder.decode(widget.token);
//     clientId = jwtDecodedToken['id'];
//     _usernameController = TextEditingController();
//     _emailController = TextEditingController();
//     initSharedPref();
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   void initSharedPref() async {
//     prefs = await SharedPreferences.getInstance();
//   }

//   Future<void> _showEditDialog(UserModel user) async {
//     _usernameController.text = user.username ?? '';
//     _emailController.text = user.email ?? '';

//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Modifier le profil'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Nom d\'utilisateur',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Annuler'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final updatedUser = UserModel(
//                   username: _usernameController.text.trim(),
//                   email: _emailController.text.trim(),
//                 );

//                 final result = await controller.updateUserById(
//                   clientId,
//                   updatedUser,
//                 );

//                 if (result['status'] == true) {
//                   if (!mounted) return;
//                   Navigator.pop(context);
//                   setState(() {});
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Profil mis à jour avec succès!'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 } else {
//                   if (!mounted) return;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Erreur: ${result['error']}'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: const Text('Enregistrer'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           'Mon Profil',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Section Avatar
//             Container(
//               margin: const EdgeInsets.only(bottom: 30),
//               child: Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   Container(
//                     width: 120,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.blue.shade100, width: 3),
//                     ),
//                     child: ClipOval(
//                       child: Image.asset(
//                         'assets/placeholder_profile.jpg',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 30, 146, 12),
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: FutureBuilder<List<UserModel>>(
//                       future: controller.getUserById(clientId),
//                       builder: (context, snapshot) {
//                         return IconButton(
//                           icon: const Icon(
//                             Icons.edit,
//                             size: 20,
//                             color: Colors.white,
//                           ),
//                           onPressed: () {
//                             if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                               _showEditDialog(snapshot.data!.first);
//                             }
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Section Informations
//             FutureBuilder<List<UserModel>>(
//               future: controller.getUserById(clientId),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       'Erreur de chargement: ${snapshot.error}',
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   );
//                 }

//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(
//                     child: Text('Aucune donnée utilisateur trouvée'),
//                   );
//                 }

//                 final user = snapshot.data!.first;
//                 return Column(
//                   children: [
//                     _buildInfoCard(
//                       title: 'Informations Personnelles',
//                       items: [
//                         _buildInfoItem(
//                           icon: Icons.person_outline,
//                           label: 'Nom d\'utilisateur',
//                           value: user.username ?? 'Non défini',
//                           //onEdit: () => _showEditDialog(user),
//                         ),
//                         _buildInfoItem(
//                           icon: Icons.email_outlined,
//                           label: 'Email',
//                           value: user.email ?? 'Non défini',
//                           //onEdit: () => _showEditDialog(user),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     _buildInfoCard(title: 'Statistiques', items: []),
//                   ],
//                 );
//               },
//             ),

//             // Boutons d'action
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 30),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildActionButton(
//                     icon: Icons.key_outlined,
//                     label: 'Porte',
//                     color: Colors.green,
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) => PortGaragePage(clientId: clientId),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildActionButton(
//                     icon: Icons.logout_outlined,
//                     label: 'Déconnexion',
//                     color: Colors.red,
//                     onPressed: () async {
//                       await prefs.remove('token');
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(builder: (context) => SigninPage()),
//                         (Route<dynamic> route) => false,
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => GeminiPage()),
//           );
//         },
//         backgroundColor: Colors.blue.shade600,
//         child: const Icon(Icons.chat_outlined, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildInfoCard({required String title, required List<Widget> items}) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[700],
//               ),
//             ),
//             const Divider(height: 20),
//             ...items,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoItem({
//     required IconData icon,
//     required String label,
//     required String value,
//     VoidCallback? onEdit,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 24, color: Colors.blue.shade600),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 2),
//                 Row(
//                   children: [
//                     Text(
//                       value,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     if (onEdit != null) ...[
//                       const Spacer(),
//                       IconButton(
//                         icon: Icon(
//                           Icons.edit,
//                           size: 18,
//                           color: Colors.blue.shade600,
//                         ),
//                         onPressed: onEdit,
//                       ),
//                     ],
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return Column(
//       children: [
//         Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             // ignore: deprecated_member_use
//             color: color.withOpacity(0.2),
//             shape: BoxShape.circle,
//           ),
//           child: IconButton(
//             icon: Icon(icon, color: color),
//             onPressed: onPressed,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: color,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }
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
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;

  @override
  void initState() {
    super.initState();
    final jwtDecodedToken = JwtDecoder.decode(widget.token);
    clientId = jwtDecodedToken['id'];
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    initSharedPref();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _showChangePasswordDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Changer le mot de passe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe actuel',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_currentPasswordController.text.isEmpty ||
                    _newPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez remplir tous les champs'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                final result = await controller.updatePassword(
                  clientId,
                  _currentPasswordController.text.trim(),
                  _newPasswordController.text.trim(),
                );

                if (result['status'] == true) {
                  if (!mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result['message'] ??
                            'Mot de passe mis à jour avec succès',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _currentPasswordController.clear();
                  _newPasswordController.clear();
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result['error'] ??
                            result['message'] ??
                            'Erreur inconnue',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(UserModel user) async {
    _usernameController.text = user.username ?? '';
    _emailController.text = user.email ?? '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedUser = UserModel(
                  username: _usernameController.text.trim(),
                  email: _emailController.text.trim(),
                );

                final result = await controller.updateUserById(
                  clientId,
                  updatedUser,
                );

                if (result['status'] == true) {
                  if (!mounted) return;
                  Navigator.pop(context);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil mis à jour avec succès!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${result['error']}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
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
                    child: FutureBuilder<List<UserModel>>(
                      future: controller.getUserById(clientId),
                      builder: (context, snapshot) {
                        return IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              _showEditDialog(snapshot.data!.first);
                            }
                          },
                        );
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
                          value: user.username ?? 'Non défini',
                          //onEdit: () => _showEditDialog(user),
                        ),
                        _buildInfoItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user.email ?? 'Non défini',
                          //onEdit: () => _showEditDialog(user),
                        ),
                      ],
                    ),
                    _buildInfoCard(
                      title: 'Sécurité',
                      items: [
                        ListTile(
                          leading: const Icon(
                            Icons.lock_outline,
                            color: Colors.blue,
                          ),
                          title: const Text('Changer le mot de passe'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: _showChangePasswordDialog,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoCard(title: 'Statistiques', items: []),
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
    VoidCallback? onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue.shade600),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (onEdit != null) ...[
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.blue.shade600,
                        ),
                        onPressed: onEdit,
                      ),
                    ],
                  ],
                ),
              ],
            ),
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
            // ignore: deprecated_member_use
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
