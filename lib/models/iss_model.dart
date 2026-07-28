class IssModel {
  final double latitude;
  final double longitude;
  final double altitude;
  final double velocity;
  final DateTime timestamp;

  IssModel({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.velocity,
    required this.timestamp,
  });

  factory IssModel.fromJson(Map<String, dynamic> json) {
    return IssModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      velocity: (json['velocity'] as num).toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          (json['timestamp'] as int) * 1000),
    );
  }
}
