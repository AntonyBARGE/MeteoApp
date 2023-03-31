import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_app_barge_antony/presentation/ui/views/home_page.dart';
import 'package:meteo_app_barge_antony/presentation/ui/views/somewhere_weather_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'routes_test.mocks.dart';

@GenerateMocks([NavigatorObserver])
void main() {
  group('HomePage navigation tests', () {
    late NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      when(mockObserver.navigator).thenAnswer((_) => NavigatorState());
    });

    Future<void> _buildMainPage(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const HomePage(),

        // This mocked observer will now receive all navigation events
        // that happen in our app.
        navigatorObservers: [mockObserver],
      ));

      // The tester.pumpWidget() call above just built our app widget
      // and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any!, any));
    }

    Future<void> _navigateToAnotherPage(WidgetTester tester) async {
      // Tap the button which should navigate to the details page.
      //
      // By calling tester.pumpAndSettle(), we ensure that all animations
      // have completed before we continue further.
      await tester.tap(find.byType(NavigationBar));
      await tester.pumpAndSettle();
    }
    testWidgets('NavBar is present and triggers navigation after tapped',
      (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: const HomePage(),
        navigatorObservers: [mockObserver],
      ),
    );

    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.tap(find.byType(NavigationBar));
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    /// You'd also want to be sure that your page is now
    /// present in the screen.
    expect(find.byType(SomewhereWeatherPage), findsOneWidget);
  });
  });
}