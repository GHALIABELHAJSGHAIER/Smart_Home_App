import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                _buildTopSection(),
                _buildWeatherDetails(),
                SizedBox(height: 20), // Ajustement pour éviter un trop grand espace
                _buildForecast(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Montreal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '19°',
            style: TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Mostly Clear',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          SizedBox(height: 5),
          Text(
            'H: 24°  L: 18°',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Image.asset('assets/images/weather_house.png', height: 180),
          // Suppression de SizedBox(height: 10) ici
          // Suppression du Container vide qui créait un espace inutile
        ],
      ),
    );
  }

  Widget _buildForecast() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Hourly Forecast',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildHourlyForecast(),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    List<Map<String, dynamic>> forecastData = [
      {'time': '12 AM', 'temp': '19°', 'icon': FontAwesomeIcons.cloudRain},
      {'time': 'Now', 'temp': '19°', 'icon': FontAwesomeIcons.cloud},
      {'time': '2 AM', 'temp': '18°', 'icon': FontAwesomeIcons.cloudMoon},
      {'time': '3 AM', 'temp': '19°', 'icon': FontAwesomeIcons.cloudSun},
      {'time': '4 AM', 'temp': '19°', 'icon': FontAwesomeIcons.cloudRain},
    ];

    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: forecastData
            .map(
              (data) => _buildHourlyItem(
                data['time'],
                data['temp'],
                data['icon'],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildHourlyItem(String time, String temp, IconData icon) {
    return Container(
      width: 90,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: TextStyle(color: Colors.white, fontSize: 14)),
          SizedBox(height: 5),
          FaIcon(icon, color: Colors.white, size: 24),
          SizedBox(height: 5),
          Text(temp, style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
