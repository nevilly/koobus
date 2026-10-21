// TODO: Define the location model.
class LocationModel {
  final double latitude;
  final double longitude;
  final double accuracy;
  final String timestamp;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
  });

  // Kubadilisha kwenda JSON ili baadaye iende kwenye Backend/API ya PHP
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'timestamp': timestamp,
    };
  }

  // Kusoma kutoka JSON
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      accuracy: json['accuracy'] ?? 0.0,
      timestamp: json['timestamp'] ?? '',
    );
  }
}
