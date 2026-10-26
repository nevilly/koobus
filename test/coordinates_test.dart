// Tests za nafasi (GPS) na uthibitisho wa pande mbili.
//
// Test hizi hazitumii mtandao. FakeCoordinateRepository inaiga upande wa
// mzazi/shule ili tuthibitishe kwamba nafasi inakuwa halali pale pande
// zote mbili zimekubali.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:provider/provider.dart';

import 'package:koobus/app/app_theme.dart';
import 'package:koobus/controllers/auth_controller.dart';
import 'package:koobus/controllers/language_controller.dart';
import 'package:koobus/core/network/api_exception.dart';
import 'package:koobus/core/storage/language_service.dart';
import 'package:koobus/core/storage/secure_session_service.dart';
import 'package:koobus/core/storage/session_service.dart';
import 'package:koobus/features/coordinates/controllers/coordinates_controller.dart';
import 'package:koobus/features/coordinates/screens/parent_coordinates_screen.dart';
import 'package:koobus/features/notifications/controllers/notifications_controller.dart';
import 'package:koobus/features/parent/screens/tabs/children_tab.dart';
import 'package:koobus/features/staff/screens/staff_shell.dart';
import 'package:koobus/l10n/app_localizations.dart';
import 'package:koobus/models/coordinate_model.dart';

import 'helpers/fake_coordinate_repository.dart';
import 'helpers/fake_notification_repository.dart';

CoordinateOverview _overview({
  CoordinateModel? childCoordinate,
  CoordinateModel? schoolCoordinate,
}) {
  return CoordinateOverview(
    children: [
      ChildCoordinateEntry(
        childId: 5,
        firstName: 'Amina',
        lastName: 'Juma',
        className: 'Darasa la 3',
        schoolId: 1,
        schoolName: 'KooBus Test School',
        coordinate: childCoordinate,
      ),
    ],
    schools: [
      SchoolCoordinateEntry(
        schoolId: 1,
        schoolName: 'KooBus Test School',
        coordinate: schoolCoordinate,
      ),
    ],
  );
}

CoordinateModel _coordinate({
  required bool parentConfirmed,
  required bool schoolConfirmed,
}) {
  return CoordinateModel(
    id: 7,
    entityType: 'child',
    entityId: 5,
    latitude: -6.792354,
    longitude: 39.208328,
    parentConfirmed: parentConfirmed,
    schoolConfirmed: schoolConfirmed,
  );
}

Future<AuthController> _loggedIn({
  String role = 'parent',
  int? schoolId,
  String displayName = 'Mtumiaji Test',
}) async {
  final store = InMemorySessionService();
  await store.saveSession(
    StoredSession(
      token: 'TEST-COORDINATES-TOKEN',
      phone: '255700000004',
      role: role,
      userId: 4,
      schoolId: schoolId,
      displayName: displayName,
    ),
  );
  final auth = AuthController(store);
  await auth.restoreSession();
  return auth;
}

Widget _wrap({required Widget home, required AuthController auth}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthController>.value(value: auth),
      ChangeNotifierProvider<LanguageController>(
        create: (_) => LanguageController(InMemoryLanguageService()),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('sw'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
    ),
  );
}

NotificationsController _notifications() {
  return NotificationsController(
    repository: FakeNotificationRepository(),
    userId: 4,
    pollInterval: Duration.zero,
  );
}

Future<void> _tapStaffTab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('CoordinatesController', () {
    test('inapakia overview ya watoto na shule', () async {
      final fake = FakeCoordinateRepository(overview: _overview());
      final controller = CoordinatesController(repository: fake);

      await controller.load();

      expect(controller.loaded, isTrue);
      expect(controller.error, isNull);
      expect(controller.children.single.fullName, 'Amina Juma');
      expect(controller.schools.single.schoolName, 'KooBus Test School');
      expect(fake.overviewCalls, 1);
      controller.dispose();
    });

    test('saveChild inahifadhi upande wa mzazi na kupakia upya', () async {
      final fake = FakeCoordinateRepository(overview: _overview());
      final controller = CoordinatesController(repository: fake);
      await controller.load();

      await controller.saveChild(
        childId: 5,
        latitude: -6.792354,
        longitude: 39.208328,
        label: 'Nyumbani',
      );

      final coordinate = controller.children.single.coordinate!;
      expect(coordinate.parentConfirmed, isTrue);
      expect(coordinate.schoolConfirmed, isFalse);
      expect(coordinate.isValid, isFalse);
      expect(coordinate.label, 'Nyumbani');
      expect(fake.calls, contains('saveChild:5'));
      expect(fake.overviewCalls, 2);
      controller.dispose();
    });

    test('confirmChild inaunganisha uthibitisho wa pande mbili', () async {
      final fake = FakeCoordinateRepository(
        overview: _overview(
          childCoordinate: _coordinate(
            parentConfirmed: true,
            schoolConfirmed: false,
          ),
        ),
      )..confirmChildSide = 'school';
      final controller = CoordinatesController(repository: fake);
      await controller.load();

      await controller.confirmChild(5);

      final coordinate = controller.children.single.coordinate!;
      expect(coordinate.parentConfirmed, isTrue);
      expect(coordinate.schoolConfirmed, isTrue);
      expect(coordinate.isValid, isTrue);
      expect(fake.calls, contains('confirmChild:5'));
      controller.dispose();
    });

    test('kosa la kuhifadhi linarekodiwa na kurudishwa', () async {
      final fake = FakeCoordinateRepository(
        overview: _overview(),
        saveChildError: const ApiException(
          statusCode: 500,
          message: 'Server imeshindikana',
        ),
      );
      final controller = CoordinatesController(repository: fake);
      await controller.load();

      await expectLater(
        controller.saveChild(
          childId: 5,
          latitude: -6.792354,
          longitude: 39.208328,
        ),
        throwsA(isA<ApiException>()),
      );

      expect(controller.error, 'Server imeshindikana');
      expect(controller.busy, isFalse);
      controller.dispose();
    });
  });

  group('ParentCoordinatesScreen', () {
    testWidgets('inaonyesha hali tupu bila watoto', (tester) async {
      final fake = FakeCoordinateRepository();
      await tester.pumpWidget(
        _wrap(
          auth: await _loggedIn(),
          home: ParentCoordinatesScreen(repository: fake),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hakuna watoto waliounganishwa'), findsOneWidget);
      expect(
        find.text(
          'Nafasi zitaonekana hapa baada ya msimamizi wa shule kuunganisha mtoto na akaunti yako.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('mzazi anathibitisha nafasi iliyoandaliwa na shule', (
      tester,
    ) async {
      final fake = FakeCoordinateRepository(
        overview: _overview(
          childCoordinate: _coordinate(
            parentConfirmed: false,
            schoolConfirmed: true,
          ),
        ),
      );
      await tester.pumpWidget(
        _wrap(
          auth: await _loggedIn(),
          home: ParentCoordinatesScreen(repository: fake),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Inasubiri mzazi'), findsWidgets);

      await tester.tap(find.widgetWithText(FilledButton, 'Thibitisha').first);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Thibitisha'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Imethibitishwa na wote'), findsOneWidget);
      expect(fake.calls, contains('confirmChild:5'));
    });
  });

  group('StaffShell', () {
    testWidgets('Matron/Patron anaona tabs nne na data ya shule', (
      tester,
    ) async {
      final fake = FakeCoordinateRepository(overview: _overview());
      final controller = CoordinatesController(repository: fake);
      final auth = await _loggedIn(
        role: 'matron',
        schoolId: 1,
        displayName: 'Matron Test',
      );

      await tester.pumpWidget(
        _wrap(
          auth: auth,
          home: StaffShell(
            controller: controller,
            notificationsController: _notifications(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Wanafunzi'), findsOneWidget);
      expect(find.text('Shule'), findsOneWidget);
      expect(find.text('Taarifa'), findsOneWidget);
      expect(find.text('Wasifu'), findsOneWidget);
      expect(find.text('Amina Juma'), findsOneWidget);

      await _tapStaffTab(tester, 'Shule');
      expect(find.text('KooBus Test School'), findsOneWidget);
      expect(find.text('Weka nafasi'), findsOneWidget);

      await _tapStaffTab(tester, 'Taarifa');
      expect(find.text('Hakuna taarifa kwa sasa.'), findsOneWidget);

      await _tapStaffTab(tester, 'Wasifu');
      expect(find.text('Taarifa za mfanyakazi'), findsOneWidget);
      expect(find.textContaining('Matron/Patron'), findsWidgets);
      expect(find.text('KooBus Test School'), findsOneWidget);
    });
  });

  testWidgets('Watoto: kadi ya nafasi inafungua screen halisi', (tester) async {
    await tester.pumpWidget(
      _wrap(
        auth: await _loggedIn(),
        home: const Scaffold(body: ChildrenTab()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('parent_coordinates_entry')), findsOneWidget);
    expect(find.text('Nafasi na uthibitisho'), findsOneWidget);
  });
}
