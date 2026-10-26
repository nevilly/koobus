// ApiEndpoints — majina ya njia za API sehemu MOJA.
//
// Sababu: kama server itabadilisha URL, tunabadilisha hapa tu badala ya
// kutafuta strings kwenye screens zote. Njia zote zinaanza na `/` na
// zinaongezwa kwenye ApiConfig.baseUrl.

class ApiEndpoints {
  const ApiEndpoints._();

  // ---- Auth ----
  static const String login = '/users/login';
  static const String profile = '/users/user';

  // ---- Trips ----
  static String tripsByDriver(int driverId) => '/trips/by_driver/$driverId';
  static String activeTripByDriver(int driverId) =>
      '/trips/active_by_driver/$driverId';
  static String trip(int id) => '/trips/get/$id';
  static String tripManifest(int id) => '/trips/manifest/$id';
  static const String tripStart = '/trips/start';
  static const String tripEnd = '/trips/end';
  static const String tripCancel = '/trips/cancel';
  static const String tripEventAdd = '/trip_events/add';
  static const String locationUpload = '/locations/upload';

  // ---- Routes / buses ----
  static String route(int id) => '/routes/get/$id';
  static String routeStops(int id) => '/routes/stops/$id';
  static String bus(int id) => '/buses/get/$id';

  // ---- Coordinates (GPS + dual confirmation) ----
  static const String coordinatesOverview = '/coordinates/overview';
  static String childCoordinate(int childId) => '/coordinates/child/$childId';
  static String childCoordinateConfirm(int childId) =>
      '/coordinates/child/$childId/confirm';
  static String schoolCoordinate(int schoolId) =>
      '/coordinates/school/$schoolId';
  static String schoolCoordinateConfirm(int schoolId) =>
      '/coordinates/school/$schoolId/confirm';
}
