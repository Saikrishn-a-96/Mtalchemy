import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mt_alchemy/routes.dart';

/// Pumps every app route at mobile width. Any layout exception
/// (overflow, unbounded constraints, missing args handling) fails
/// the test at the offending route.
void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  const routes = [
    '/',
    '/about',
    '/services',
    '/upskilling',
    '/course',
    '/register',
    '/login',
    '/dashboard',
    '/player',
    '/quiz',
    '/certificate',
    '/store',
    '/product',
    '/cart',
    '/checkout',
    '/confirmation',
    '/orders',
    '/digital-library',
    '/insights',
    '/contact',
    '/employer',
    '/employer/employees',
    '/employer/assign',
    '/employer/reports',
    '/admin',
  ];

  testWidgets('every route builds at mobile width without errors',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    for (final r in routes) {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: onGenerateRoute,
          initialRoute: r,
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      final err = tester.takeException();
      expect(err, isNull, reason: 'route $r');
    }
  });
}
