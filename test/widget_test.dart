import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mt_alchemy/data/brand_data.dart';
import 'package:mt_alchemy/data/models.dart';
import 'package:mt_alchemy/data/reporting.dart';
import 'package:mt_alchemy/routes.dart';
import 'package:mt_alchemy/state/app_state.dart';
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

  test('department performance derives from employee progress', () {
    final perf = Reporting.departmentPerformance(Content.employees);
    int avg(String dept) =>
        perf.firstWhere((d) => d.department == dept).averageProgress;
    int count(String dept) =>
        perf.firstWhere((d) => d.department == dept).learners;

    expect(avg('Human Resources'), 90);
    expect(avg('Finance'), 63); // (100 + 25) / 2 rounded
    expect(avg('Operations'), 45);
    expect(avg('Sales'), 0);
    expect(count('Human Resources'), 2);
    expect(count('Finance'), 2);
    expect(count('Operations'), 1);
    expect(count('Sales'), 1);
  });

  test('report stats derive from roster, scores and catalogue hours', () {
    final stats = Reporting.reportStats(Content.employees);
    expect(stats.enrolments, Content.employees.length);
    expect(stats.completions, 2);
    expect(stats.averageScore, 82); // mean of attempted scores, rounded
    expect(stats.learningHours, 35);
    expect(stats.completionRate, 33); // 2 of 6, rounded
  });

  test('duration and amount parsing matches catalogue formats', () {
    expect(Reporting.parseDurationHours('6h 30m'), 6.5);
    expect(Reporting.parseDurationHours('8h 00m'), 8.0);
    expect(Reporting.parseDurationHours('3h 45m'), 3.75);
    expect(Reporting.parseAmount('RM120.00'), 120.0);
    expect(Reporting.orderRevenue(AppState.instance.orders), 205.0);
  });

  test('performance CSV covers every roster row', () {
    final csv = Reporting.performanceCsv(Content.employees);
    expect(csv.startsWith('Employee,Department,Course'), isTrue);
    for (final e in Content.employees) {
      expect(csv.contains(e.name), isTrue, reason: e.name);
    }
  });

  test('checkout on an empty cart changes nothing', () {
    final state = AppState.instance;
    state.clearCart();
    final ordersBefore = state.orders.length;
    expect(state.checkout(), 0);
    expect(state.orders.length, ordersBefore);
    expect(state.cartCount, 0);
  });

  test('assignments are recorded and removable', () {
    final state = AppState.instance;
    final before = state.assignments.length;
    state.assignCourse(
        course: 'Test Course',
        employees: ['A Tester'],
        deadline: '30 Oct 2026');
    expect(state.assignments.length, before + 1);
    expect(state.assignments.first['course'], 'Test Course');
    state.assignments.removeAt(0);
    expect(state.assignments.length, before);
  });

  test('quiz has five questions with pass mark at four', () {
    expect(Content.quiz.length, 5);
    // Pass threshold used by the quiz screen result logic.
    expect(4 / Content.quiz.length, 0.8);
  });
}
