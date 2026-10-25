// Tests za models: parsing ya JSON kutoka API.
//
// Hizi ni "hesabu" tu (hakuna UI): tunahakikisha kwamba jibu la server
// linatafsiriwa sawa, hasa role na status za safari.

import 'package:flutter_test/flutter_test.dart';

import 'package:koobus/models/route_model.dart';
import 'package:koobus/models/route_stop_model.dart';
import 'package:koobus/models/trip_model.dart';
import 'package:koobus/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('inasoma id, role na jina kamili', () {
      final user = UserModel.fromJson({
        'id': 7,
        'role': 'driver',
        'first_name': 'Juma',
        'last_name': 'Hamisi',
        'phone': '0712345678',
        'school_id': '3',
      });

      expect(user.id, 7);
      expect(user.role, UserRole.driver);
      expect(user.isDriver, isTrue);
      expect(user.roleValue, 'driver');
      expect(user.displayName, 'Juma Hamisi');
      expect(user.schoolId, 3);
    });

    test('role isiyojulikana inakuwa unknown', () {
      final user = UserModel.fromJson({'id': 1, 'role': 'cleaner'});

      expect(user.role, UserRole.unknown);
      expect(user.roleValue, 'unknown');
    });

    test('displayName inatumia username kama jina halipo', () {
      final user = UserModel.fromJson({
        'id': 2,
        'role': 'parent',
        'username': 'mzazi1',
      });

      expect(user.displayName, 'mzazi1');
    });
  });

  group('TripModel', () {
    test('inasoma status, tarehe na driver', () {
      final trip = TripModel.fromJson({
        'id': 10,
        'route_id': 3,
        'bus_id': 2,
        'driver_id': 7,
        'matron_id': 9,
        'trip_type': 'morning',
        'status': 'active',
        'started_at': '2026-10-25 07:30:00',
        'created_at': '2026-10-25 06:00:00',
      });

      expect(trip.id, 10);
      expect(trip.routeId, 3);
      expect(trip.busId, 2);
      expect(trip.driverId, 7);
      expect(trip.matronId, 9);
      expect(trip.status, TripStatus.active);
      expect(trip.isActive, isTrue);
      expect(trip.startedAt, isNotNull);
      expect(trip.createdAt, isNotNull);
    });

    test('status isiyojulikana haitupi kosa', () {
      final trip = TripModel.fromJson({'id': 1, 'status': 'delayed'});

      expect(trip.status, TripStatus.unknown);
    });

    test('isToday inatumia created_at', () {
      final today = TripModel.fromJson({
        'id': 1,
        'created_at': DateTime.now().toIso8601String(),
      });
      final old = TripModel.fromJson({
        'id': 2,
        'created_at': DateTime.now()
            .subtract(const Duration(days: 2))
            .toIso8601String(),
      });

      expect(today.isToday, isTrue);
      expect(old.isToday, isFalse);
    });

    test('copyWith inabadilisha status tu', () {
      const trip = TripModel(
        id: 5,
        routeId: 1,
        busId: 2,
        driverId: 3,
        tripType: 'afternoon',
        status: TripStatus.pending,
      );

      final active = trip.copyWith(status: TripStatus.active);

      expect(active.id, 5);
      expect(active.driverId, 3);
      expect(active.status, TripStatus.active);
    });
  });

  group('RouteModel na RouteStopModel', () {
    test('inasoma route', () {
      final route = RouteModel.fromJson({
        'id': 3,
        'school_id': 2,
        'name': 'Route A',
        'description': 'Kariakoo - Upanga',
      });

      expect(route.id, 3);
      expect(route.schoolId, 2);
      expect(route.name, 'Route A');
      expect(route.description, 'Kariakoo - Upanga');
    });

    test('inasoma kituo na mpangilio', () {
      final stop = RouteStopModel.fromJson({
        'id': 11,
        'route_id': 3,
        'name': 'Kariakoo',
        'stop_order': 2,
        'latitude': '-6.818',
        'longitude': 39.28,
      });

      expect(stop.id, 11);
      expect(stop.routeId, 3);
      expect(stop.name, 'Kariakoo');
      expect(stop.stopOrder, 2);
      expect(stop.latitude, closeTo(-6.818, 0.0001));
      expect(stop.longitude, closeTo(39.28, 0.0001));
    });
  });
}
