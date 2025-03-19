import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilePage extends StatelessWidget {
  const FilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("files")),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background_image.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Text(
                "Hello from Files page",
                style: GoogleFonts.bebasNeue(fontSize: 20, color: Colors.white),
              ),
              Text(
                "Hello from Files page",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Hello from Files page",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}