import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/colombia_model.dart';
import '../models/region_model.dart';
import '../models/attraction_model.dart';
import '../models/iss_model.dart';
import '../models/weather_model.dart';

class ApiService {
  static const String _colombiaBaseUrl = 'https://api-colombia.com/api/v1';
  static const String _issUrl =
      'https://api.wheretheiss.at/v1/satellites/25544';

  // Reemplaza este valor con tu API key real de OpenWeatherMap si el placeholder expira
  static const String _weatherApiKey = 'bbf3f766ba0238f9b77996f643f490f0';

  Future<CountryModel> getColombiaGeneral() async {
    final response =
        await http.get(Uri.parse('$_colombiaBaseUrl/Country/Colombia'));
    if (response.statusCode == 200) {
      return CountryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar datos generales de Colombia');
    }
  }

  Future<List<RegionModel>> getRegions() async {
    final response = await http.get(Uri.parse('$_colombiaBaseUrl/Region'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => RegionModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar las regiones');
    }
  }

  Future<List<AttractionModel>> getAttractions() async {
    final response =
        await http.get(Uri.parse('$_colombiaBaseUrl/TouristicAttraction'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => AttractionModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar sitios turísticos');
    }
  }

  Future<IssModel> getIssLocation() async {
    final response = await http.get(Uri.parse(_issUrl));
    if (response.statusCode == 200) {
      return IssModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al conectar con el satélite ISS');
    }
  }

  Future<WeatherModel> getWeatherByCity(String city) async {
    final encodedCity = Uri.encodeComponent(city);
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$encodedCity&appid=$_weatherApiKey&units=metric&lang=es';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ciudad no encontrada o error en el servicio de clima');
    }
  }
}
