import 'package:flutter/material.dart';
import 'package:clone_spotify_mars/models/music_model.dart';
import 'package:clone_spotify_mars/screens/espace_page.dart';  // Import de la page EspacePage

class NouveauteWidget extends StatelessWidget {
  const NouveauteWidget({super.key, required this.musicModel});
  final MusicModel musicModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image de la musique avec un GestureDetector pour gérer le clic
          GestureDetector(
            onTap: () {
              // Naviguer vers la page EspacePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EspacePage(title: musicModel.title),  // Passer le titre à la page EspacePage
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                musicModel.photo,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            musicModel.artist,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            musicModel.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
