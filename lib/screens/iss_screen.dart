import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/app_provider.dart';

class IssScreen extends StatefulWidget {
  const IssScreen({super.key});

  @override
  State<IssScreen> createState() => _IssScreenState();
}

class _IssScreenState extends State<IssScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().startIssTracking();
    });
  }

  @override
  void dispose() {
    // Evitamos llamadas innecesarias al API al salir de la pantalla
    context.read<AppProvider>().stopIssTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (provider.issState == LoadingState.loading && provider.issData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    LatLng targetPosition = const LatLng(0, 0);
    if (provider.issData != null) {
      targetPosition =
          LatLng(provider.issData!.latitude, provider.issData!.longitude);
      // Mueve el mapa suavemente al actualizar la posición
      _mapController.move(targetPosition, _mapController.camera.zoom);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Rastreo de la ISS en Tiempo Real')),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: targetPosition,
                initialZoom: 2.5,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.multi_api_dashboard',
                ),
                if (provider.issData != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: targetPosition,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.rocket_launch,
                            color: Colors.deepOrange, size: 36),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blueGrey[900],
              width: double.infinity,
              child: provider.issData == null
                  ? const Center(
                      child: Text('Conectando con satélites...',
                          style: TextStyle(color: Colors.white)))
                  : Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Métricas de Órbita Actualizadas (5s)',
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            const SizedBox(height: 16),
                            Table(
                              children: [
                                _tableRow('Latitud:',
                                    '${provider.issData!.latitude.toStringAsFixed(4)}°'),
                                _tableRow('Longitud:',
                                    '${provider.issData!.longitude.toStringAsFixed(4)}°'),
                                _tableRow('Altitud:',
                                    '${provider.issData!.altitude.toStringAsFixed(2)} km'),
                                _tableRow('Velocidad:',
                                    '${provider.issData!.velocity.toStringAsFixed(2)} km/h'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  TableRow _tableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ],
    );
  }
}
