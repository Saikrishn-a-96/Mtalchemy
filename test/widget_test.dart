import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mt_alchemy/data/brand_data.dart';
import 'package:mt_alchemy/data/models.dart';
import 'package:mt_alchemy/routes.dart';
import 'package:mt_alchemy/theme/app_theme.dart';

void main() {
  test('brand palette matches the MT Alchemy brief', () {
    expect(const Color(0xFF0C2340), AppColors.deepBlue); // Deep Blue
    expect(const Color(0xFFF5C542), AppColors.softYellow); // Soft Yellow
    expect(const Color(0xFF6B4E9B), AppColors.purple); // Purple
  });

  test('every portal route is wrapped by the portal shell', () {
    for (final route in const [
      '/dashboard',
      '/employer',
      '/employer/employees',
      '/employer/assign',
      '/employer/reports',
      '/admin',
    ]) {
      expect(portalRoutes.contains(route), isTrue, reason: route);
    }
    expect(portalRoutes.contains('/'), isFalse);
  });

  test('learning content used by the prototype is complete', () {
    expect(Content.courses.length, greaterThanOrEqualTo(6));
    expect(Content.products.length, greaterThanOrEqualTo(6));
    expect(Content.services.length, greaterThanOrEqualTo(6));
    expect(Content.quiz.length, greaterThanOrEqualTo(5));

    for (final Course c in Content.courses) {
      expect(c.modules, greaterThan(0), reason: c.title);
      expect(c.image.startsWith('https://'), isTrue, reason: c.title);
    }
    for (final Product p in Content.products) {
      expect(p.price, greaterThan(0), reason: p.name);
      expect(p.image.startsWith('https://'), isTrue, reason: p.name);
    }
  });
}
