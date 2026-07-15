class WeatherModel {
  final String cityName;
  final double temp;
  final int humidity;
  final double lat;
  final double lon;
  final String description;

  WeatherModel({
    required this.cityName,
    required this.temp,
    required this.humidity,
    required this.lat,
    required this.lon,
    required this.description,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      temp: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      lat: (json['coord']['lat'] as num).toDouble(),
      lon: (json['coord']['lon'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
    );
  }
}
