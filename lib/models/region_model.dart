class RegionModel {
  final int id;
  final String name;
  final String? description;

  RegionModel({required this.id, required this.name, this.description});

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
