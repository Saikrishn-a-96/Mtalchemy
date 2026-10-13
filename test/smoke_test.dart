import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mt_alchemy/screens/public/about_screen.dart';
import 'package:mt_alchemy/screens/public/services_screen.dart';

/// Pumps a full public page inside a scroll view (mirroring AppShell)
/// and lets the caller assert on its content. The scroll view lays out
/// every section, so any layout exception fails the test.
Future<void> _pumpPage(
    WidgetTester tester, Widget page, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    MaterialApp(
      home: ScrollConfiguration(
        behavior: _NoOverscrollGlow(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: page,
          ),
        ),
      ),
    ),
  );
  // A single pump jumps entrance animations to their end state.
  // (Stepping through mid-animation frames trips a semantics/layout
  // race in the test harness — a framework artifact, not app layout.)
  await tester.pump(const Duration(seconds: 3));
}

/// Test-harness scroll behavior without the Material stretch/glow
/// overscroll indicator, whose animation races layout in widget tests.
class _NoOverscrollGlow extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

void main() {
  // Widget tests have no network: stop google_fonts from fetching
  // font files at runtime (its async completion races layout and
  // trips framework assertions). Widgets fall back to default fonts.
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('about page builds and scrolls without errors (desktop)',
      (tester) async {
    await _pumpPage(
        tester, const AboutScreen(), const Size(1280, 800));
    expect(find.text('Who we are'), findsWidgets);
    expect(find.text('Our reach'), findsOneWidget);
    expect(find.text('Mabel Tan KH'), findsWidgets);
  });

  testWidgets('about page builds and scrolls without errors (mobile)',
      (tester) async {
    await _pumpPage(
        tester, const AboutScreen(), const Size(390, 844));
    expect(find.text('Who we are'), findsWidgets);
    expect(find.text('Our reach'), findsOneWidget);
  });

  testWidgets('services page builds and scrolls without errors (desktop)',
      (tester) async {
    await _pumpPage(
        tester, const ServicesScreen(), const Size(1280, 800));
    expect(find.text('Service directory'), findsOneWidget);
    expect(find.text('Browse programmes'), findsOneWidget);
  });

  testWidgets('services page builds and scrolls without errors (mobile)',
      (tester) async {
    await _pumpPage(
        tester, const ServicesScreen(), const Size(390, 844));
    expect(find.text('Service directory'), findsOneWidget);
    expect(find.text('One-to-one coaching'), findsOneWidget);
  });
}
