import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/weather_provider.dart';
import '../providers/app_provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Buscador Meteorológico')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: 'Introduce una ciudad (ej. London, Bogotá)',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onSubmitted: (val) => provider.searchWeather(val),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 24),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () =>
                          provider.searchWeather(_cityController.text),
                      child: const Icon(Icons.search),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                if (provider.weatherState == LoadingState.loading)
                  const CircularProgressIndicator()
                else if (provider.weatherState == LoadingState.error)
                  Text(provider.errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16))
                else if (provider.weatherState == LoadingState.success &&
                    provider.weatherData != null)
                  _buildWeatherDashboard(provider.weatherData!)
                else
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                        'Busca una ciudad para visualizar su reporte climático gráfico.',
                        style: TextStyle(color: Colors.grey)),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDashboard(dynamic data) {
    final coords = LatLng(data.lat, data.lon);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${data.cityName}',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text(data.description.toUpperCase(),
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        // Sección Gráfica
        LayoutBuilder(
          builder: (context, constraints) {
            bool useVertical = constraints.maxWidth < 600;
            return useVertical
                ? Column(children: [
                    _chartCard('Temperatura', _buildTempBarChart(data.temp)),
                    const SizedBox(height: 16),
                    _chartCard('Humedad', _buildHumidityGauge(data.humidity))
                  ])
                : Row(children: [
                    Expanded(
                        child: _chartCard(
                            'Temperatura', _buildTempBarChart(data.temp))),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _chartCard(
                            'Humedad', _buildHumidityGauge(data.humidity)))
                  ]);
          },
        ),
        const SizedBox(height: 24),

        // Mapa de Ubicación de la Ciudad
        const Text('Geolocalización',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FlutterMap(
              options: MapOptions(initialCenter: coords, initialZoom: 10),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                        point: coords,
                        child: const Icon(Icons.location_on,
                            color: Colors.blue, size: 40)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chartCard(String title, Widget chart) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(height: 140, child: chart),
          ],
        ),
      ),
    );
  }

  Widget _buildTempBarChart(double temp) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.center,
        maxY: 50,
        minY: -10,
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: temp,
                color: temp > 20 ? Colors.orange : Colors.blue,
                width: 35,
                borderRadius: BorderRadius.circular(6),
                backDrawRodData: BackgroundBarChartRodData(
                    show: true, toY: 50, color: Colors.grey[200]),
              )
            ],
          )
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (_, __) =>
                      Text('${temp.toStringAsFixed(1)} °C'))),
          leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
      ),
    );
  }

  Widget _buildHumidityGauge(int humidity) {
    return PieChart(
      PieChartData(
        startDegreeOffset: 270,
        sections: [
          PieChartSectionData(
              color: Colors.teal,
              value: humidity.toDouble(),
              radius: 25,
              title: '$humidity%',
              titleStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          PieChartSectionData(
              color: Colors.grey[300],
              value: (100 - humidity).toDouble(),
              radius: 20,
              showTitle: false),
        ],
      ),
    );
  }
}
