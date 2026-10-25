// RouteStopModel — kituo kimoja kwenye route (route_stops table).
//
// `stopOrder` ndiyo mpangilio wa safari. Server inarudisha vituo
// vikiwa vimepangwa; client haipaswi kupanga upya kwa bahati.

class RouteStopModel {
  const RouteStopModel({
    required this.id,
    required this.routeId,
    required this.name,
    required this.stopOrder,
    this.latitude,
    this.longitude,
  });

  final int id;
  final int routeId;
  final String name;
  final int stopOrder;
  final double? latitude;
  final double? longitude;

  factory RouteStopModel.fromJson(Map<String, dynamic> json) {
    return RouteStopModel(
      id: _int(json['id']),
      routeId: _int(json['route_id']),
      name: json['name']?.toString() ?? '',
      stopOrder: _int(json['stop_order']),
      latitude: _doubleOrNull(json['latitude']),
      longitude: _doubleOrNull(json['longitude']),
    );
  }

  static int _int(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static double? _doubleOrNull(Object? value) {
    if (value == null || value.toString().trim().isEmpty) return null;
    return value is num ? value.toDouble() : double.tryParse('$value');
  }
}
