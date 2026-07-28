import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AttractionsScreen extends StatefulWidget {
  const AttractionsScreen({super.key});

  @override
  State<AttractionsScreen> createState() => _AttractionsScreenState();
}

class _AttractionsScreenState extends State<AttractionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().fetchAttractions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Sitios Turísticos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o ciudad...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              provider.filterAttractions('');
                            },
                          )
                        : null,
                  ),
                  onChanged: (val) => provider.filterAttractions(val),
                ),
              ),
            ),
          ),
          Expanded(
            child: provider.attractionsState == LoadingState.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.attractionsState == LoadingState.error
                    ? Center(child: Text('Error: ${provider.errorMessage}'))
                    : Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: provider.filteredAttractions.length,
                            itemBuilder: (context, index) {
                              final place = provider.filteredAttractions[index];
                              final hasImage = place.images != null &&
                                  place.images!.isNotEmpty;

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                clipBehavior: Clip.antiAlias,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      color: Colors.grey[200],
                                      child: hasImage
                                          ? Image.network(
                                              place.images![0],
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(Icons.broken_image,
                                                      size: 40,
                                                      color: Colors.grey),
                                            )
                                          : const Icon(Icons.image,
                                              size: 40, color: Colors.grey),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(place.name,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            const SizedBox(height: 4),
                                            if (place.cityName != null)
                                              Row(
                                                children: [
                                                  const Icon(Icons.location_on,
                                                      size: 14,
                                                      color: Colors.red),
                                                  const SizedBox(width: 4),
                                                  Text(place.cityName!,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[700],
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              ),
                                            const SizedBox(height: 6),
                                            Text(place.description,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black87),
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
