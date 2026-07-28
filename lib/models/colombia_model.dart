class CountryModel {
  final String name;
  final String capital;
  final int population;
  final double surface;
  final String currency;
  final String language;
  final String description;

  CountryModel({
    required this.name,
    required this.capital,
    required this.population,
    required this.surface,
    required this.currency,
    required this.language,
    required this.description,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'] ?? 'Colombia',
      capital: json['capital'] ?? 'Bogotá',
      population: json['population'] ?? 51000000,
      surface: (json['surface'] as num?)?.toDouble() ?? 1141748.0,
      currency: json['currency'] ?? 'COP (Peso Colombiano)',
      language: json['languages']?[0] ?? 'Español',
      description: json['description'] ?? '',
    );
  }
}
