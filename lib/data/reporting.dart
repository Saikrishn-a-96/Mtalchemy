import 'brand_data.dart';
import 'models.dart';

/// Pure, testable derivations over the prototype data.
///
/// Every dashboard/report figure in the app is computed here so portal
/// numbers can never disagree with the underlying employee, course and
/// order data. All source lists are sample/demo data for the prototype.
class Reporting {
  Reporting._();

  /// Average progress (0–100) per department, plus learner headcount.
  /// Departments follow first-seen order in [employees].
  static List<DeptPerformance> departmentPerformance(
      List<Employee> employees) {
    final order = <String>[];
    final sums = <String, int>{};
    final counts = <String, int>{};
    for (final e in employees) {
      if (!sums.containsKey(e.department)) {
        order.add(e.department);
        sums[e.department] = 0;
        counts[e.department] = 0;
      }
      sums[e.department] = sums[e.department]! + e.progress;
      counts[e.department] = counts[e.department]! + 1;
    }
    return [
      for (final d in order)
        DeptPerformance(
          department: d,
          averageProgress:
              (sums[d]! / counts[d]!).round(),
          learners: counts[d]!,
        ),
    ];
  }

  /// Headline report figures derived from the learner roster.
  static ReportStats reportStats(List<Employee> employees) {
    final completions =
        employees.where((e) => e.progress >= 100).length;
    final scores =
        employees.where((e) => e.score > 0).map((e) => e.score).toList();
    final avgScore = scores.isEmpty
        ? 0
        : (scores.reduce((a, b) => a + b) / scores.length).round();
    return ReportStats(
      enrolments: employees.length,
      completions: completions,
      averageScore: avgScore,
      learningHours: learningHoursFor(
          employees.map((e) => e.course).toList()),
    );
  }

  /// Total assigned learning hours, resolved by matching course titles
  /// against the catalogue and parsing their durations. Matches tolerate
  /// short titles stored on roster rows (e.g. 'Lead with Clarity').
  static int learningHoursFor(List<String> courseTitles) {
    double hours = 0;
    for (final title in courseTitles) {
      final match = Content.courses.where((c) =>
          c.title == title ||
          c.id == title ||
          c.title.contains(title) ||
          title.contains(c.title));
      if (match.isEmpty) continue;
      hours += parseDurationHours(match.first.duration);
    }
    return hours.round();
  }

  /// Parses catalogue durations such as '6h 30m' or '8h 00m' into hours.
  static double parseDurationHours(String duration) {
    final match =
        RegExp(r'(?:(\d+)\s*h)?\s*(?:(\d+)\s*m)?').firstMatch(duration);
    if (match == null) return 0;
    final h = int.tryParse(match.group(1) ?? '0') ?? 0;
    final m = int.tryParse(match.group(2) ?? '0') ?? 0;
    return h + m / 60.0;
  }

  /// Parses order amounts such as 'RM120.00' into a double.
  static double parseAmount(String amount) {
    return double.tryParse(
            amount.replaceAll(RegExp(r'[^0-9.]'), '')) ??
        0;
  }

  /// Sums the `amount` field of prototype order records.
  static double orderRevenue(List<Map<String, dynamic>> orders) {
    return orders.fold(
        0, (sum, o) => sum + parseAmount('${o['amount']}'));
  }

  /// Builds a CSV export of individual performance rows.
  static String performanceCsv(List<Employee> employees) {
    final buf = StringBuffer('Employee,Department,Course,Progress %,Score %,Status\n');
    for (final e in employees) {
      buf.writeln(
          '${_csv(e.name)},${_csv(e.department)},${_csv(e.course)},${e.progress},${e.score > 0 ? e.score : '—'},${_csv(e.status)}');
    }
    return buf.toString();
  }

  static String _csv(String value) {
    if (value.contains(',') || value.contains('"')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}

class DeptPerformance {
  final String department;
 final int averageProgress;
  final int learners;

  const DeptPerformance({
    required this.department,
    required this.averageProgress,
    required this.learners,
  });

  String get learnersLabel =>
      '$learners learner${learners == 1 ? '' : 's'}';
}

class ReportStats {
  final int enrolments;
  final int completions;
  final int averageScore;
  final int learningHours;

  const ReportStats({
    required this.enrolments,
    required this.completions,
    required this.averageScore,
    required this.learningHours,
  });

  /// Share of enrolled learners who completed (0–100).
  int get completionRate =>
      enrolments == 0 ? 0 : ((completions / enrolments) * 100).round();
}
