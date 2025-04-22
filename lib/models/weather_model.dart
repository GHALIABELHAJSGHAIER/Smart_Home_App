class WeatherModel {
  final double temperature;
  final String weather;

  WeatherModel({required this.temperature, required this.weather});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['current']['temperature_2m'] ?? 0.0,
      weather:
          json['current']['weathercode'].toString(), // you can decode the code
    );
  }
}
