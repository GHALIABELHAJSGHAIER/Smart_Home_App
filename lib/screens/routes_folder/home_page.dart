import 'package:clone_spotify_mars/screens/ajouter_Maison_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clone_spotify_mars/models/music_model.dart';
import '../components/nouveaute_widget.dart';

class HomePage extends StatelessWidget {
  final List<String> userAvatars = [
    'assets/images/maison.png',
    'assets/images/maison.png',
    'assets/images/maison.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 251, 251), // Fond noir
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "28°",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Texte noir
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AjouterMaisonPage(),
                          ),
                        );
                      },
                      backgroundColor: Color(0xFFA67B5B),
                      child: Icon(Icons.add, color: Colors.white),
                      mini: true,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Hi Ghalia",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Texte noir
                  ),
                ),
                Text(
                  "Welcome to smart home +",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black, // Texte noir
                  ),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var avatar in userAvatars)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(avatar),
                          ),
                        ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.add, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Music",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Texte noir
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
                  ],
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: musicList.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder:
                        (context, index) =>
                            NouveauteWidget(musicModel: musicList[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
