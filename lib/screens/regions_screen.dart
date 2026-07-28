import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/region_model.dart';

class RegionsScreen extends StatefulWidget {
  const RegionsScreen({super.key});

  @override
  State<RegionsScreen> createState() => _RegionsScreenState();
}

class _RegionsScreenState extends State<RegionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().fetchRegions();
    });
  }

  void _showRegionDetail(RegionModel region) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(region.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.blue)),
              const Divider(height: 24),
              const Text('Descripción de la Región:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                region.description ??
                    'Esta magnífica región forma parte de los ecosistemas vitales y culturales de Colombia.',
                style: const TextStyle(fontSize: 15, height: 1.4),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cerrar')),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Regiones de Colombia')),
      body: provider.regionsState == LoadingState.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.regionsState == LoadingState.error
              ? Center(child: Text('Error: ${provider.errorMessage}'))
              : Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: provider.regions.length,
                      itemBuilder: (context, index) {
                        final region = provider.regions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.map_outlined,
                                color: Colors.blue),
                            title: Text(region.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => _showRegionDetail(region),
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
