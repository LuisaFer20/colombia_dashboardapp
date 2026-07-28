import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'package:intl/intl.dart';

class ColombiaScreen extends StatefulWidget {
  const ColombiaScreen({super.key});

  @override
  State<ColombiaScreen> createState() => _ColombiaScreenState();
}

class _ColombiaScreenState extends State<ColombiaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().fetchCountryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final fmt = NumberFormat.decimalPattern();

    return Scaffold(
      appBar: AppBar(title: const Text('Información General de Colombia')),
      body: _buildBody(provider, fmt),
    );
  }

  Widget _buildBody(AppProvider provider, NumberFormat fmt) {
    if (provider.countryState == LoadingState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.countryState == LoadingState.error) {
      return Center(child: Text('Error: ${provider.errorMessage}'));
    }
    if (provider.countryData == null) return const SizedBox();

    final data = provider.countryData!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(data.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(data.description,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _infoCard('Capital', data.capital, Icons.location_city,
                      Colors.orange),
                  _infoCard('Población', '${fmt.format(data.population)} Hab.',
                      Icons.people, Colors.blue),
                  _infoCard('Superficie', '${fmt.format(data.surface)} km²',
                      Icons.landscape, Colors.green),
                  _infoCard(
                      'Moneda', data.currency, Icons.attach_money, Colors.teal),
                  _infoCard(
                      'Idioma', data.language, Icons.translate, Colors.purple),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color)),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        subtitle: Text(value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
