import 'package:flutter/material.dart';

class AppareilPage extends StatefulWidget {
  @override
  _AppareilPageState createState() => _AppareilPageState();
}

class _AppareilPageState extends State<AppareilPage> {
  bool isLightOn = false;
  bool isAcOn = false;
  bool isTvOn = false;
  bool isFanOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(
          "Appareils - Nom Espace",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Température = 24.9°",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  "Humidité = 69%",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.2,
                    children: [
                      _buildDeviceCard(
                        "Smart Light",
                        Icons.lightbulb,
                        isLightOn,
                        (value) {
                          setState(() => isLightOn = value);
                        },
                      ),
                      _buildDeviceCard("Smart AC", Icons.ac_unit, isAcOn, (
                        value,
                      ) {
                        setState(() => isAcOn = value);
                      }),
                      _buildDeviceCard("Smart TV", Icons.tv, isTvOn, (value) {
                        setState(() => isTvOn = value);
                      }),
                      _buildDeviceCard("Smart Fan", Icons.toys, isFanOn, (
                        value,
                      ) {
                        setState(() => isFanOn = value);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard(
    String title,
    IconData icon,
    bool isOn,
    Function(bool) onChanged,
  ) {
    return Card(
      color: isOn ? Colors.black :   Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: isOn ? Colors.white : Colors.black),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: isOn ? Colors.white : Colors.black),
            ),
            Switch(
              value: isOn,
              onChanged: onChanged,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
