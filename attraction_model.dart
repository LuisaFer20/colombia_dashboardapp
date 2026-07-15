class AttractionModel {
  final int id;
  final String name;
  final String description;
  final List<String>? images;
  final String? cityName;

  AttractionModel({
    required this.id,
    required this.name,
    required this.description,
    this.images,
    this.cityName,
  });

  factory AttractionModel.fromJson(Map<String, dynamic> json) {
    return AttractionModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      cityName: json['city']?['name'],
    );
  }
}
