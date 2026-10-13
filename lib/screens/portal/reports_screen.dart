import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/reporting.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../../widgets/portal_shell.dart';
import 'employer_dashboard_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  void _exportCsv(BuildContext context) {
    final csv =
        Reporting.performanceCsv(AppState.instance.roster);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.table_chart_rounded, color: AppColors.indigo),
            SizedBox(width: 10),
            Text('Export report (CSV)'),
          ],
        ),
        content: SizedBox(
          width: 560,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Generated from the current learner roster. Copy it into any spreadsheet app.',
                style: TextStyle(fontSize: 13.5, height: 1.5),
              ),
              const SizedBox(height: 12),
              Container(
                constraints: const BoxConstraints(maxHeight: 220),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(csv,
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: csv));
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('CSV copied to clipboard')),
                );
              }
            },
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: const Text('Copy CSV'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final stats = Reporting.reportStats(state.roster);
    final depts = Reporting.departmentPerformance(state.roster);
    final certified =
        state.roster.where((e) => e.progress >= 100).toList();

    return PortalShell(
      title: 'Corporate learning reports',
      subtitle: 'Overall, department and individual performance · sample data',
      activeRoute: '/employer/reports',
      items: EmployerDashboardScreen.items,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Reporting period: 1 Sep – 12 Oct 2026 · sample data',
                    style: TextStyle(
                        color: AppColors.muted, fontWeight: FontWeight.w600)),
              ),
              PrimaryButton(
                label: 'Export CSV',
                icon: Icons.table_chart_rounded,
                compact: true,
                onPressed: () => _exportCsv(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ResponsiveBuilder(
            builder: (context, type) {
              final tiles = [
                StatTile(
                    value: '${stats.enrolments}',
                    label: 'Enrolments',
                    icon: Icons.menu_book_rounded,
                    accent: AppColors.deepBlue),
                StatTile(
                    value: '${stats.completions}',
                    label: 'Completions',
                    icon: Icons.check_rounded,
                    accent: AppColors.success),
                StatTile(
                    value: '${stats.averageScore}%',
                    label: 'Average score',
                    icon: Icons.grade_rounded,
                    accent: AppColors.softYellow),
                StatTile(
                    value: '${stats.learningHours}h',
                    label: 'Assigned learning hours',
                    icon: Icons.schedule_rounded,
                    accent: AppColors.purple),
              ];
              if (type == ScreenType.mobile) {
                return Column(
                  children: [
                    for (final t in tiles)
                      Padding(
                          padding: const EdgeInsets.only(bottom: 14), child: t),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < tiles.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    Expanded(child: tiles[i]),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          ResponsiveBuilder(
            builder: (context, type) {
              final dept = Panel(
                title: 'Department performance',
                trailing: const Tag(
                    label: 'SAMPLE', color: AppColors.warning),
                child: Column(
                  children: [
                    for (final d in depts)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(d.department,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                                const SizedBox(width: 10),
                                Text(d.learnersLabel,
                                    style: const TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.muted)),
                                const Spacer(),
                                Text('${d.averageProgress}%',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.deepBlue)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TweenAnimationBuilder<double>(
                              tween: Tween(
                                  begin: 0,
                                  end: d.averageProgress / 100),
                              duration: 900.ms,
                              curve: Curves.easeOutCubic,
                              builder: (context, v, _) => ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value: v,
                                  minHeight: 10,
                                  backgroundColor: AppColors.border,
                                  valueColor: AlwaysStoppedAnimation(
                                    d.averageProgress >= 100
                                        ? AppColors.success
                                        : AppColors.purple,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Text(
                      'Averages are computed live from each learner’s course progress.',
                      style: TextStyle(
                          fontSize: 12.5, color: AppColors.muted),
                    ),
                  ],
                ),
              );

              final certs = Panel(
                title: 'Certificates earned',
                child: Column(
                  children: [
                    if (certified.isEmpty)
                      const Text(
                        'No certificates yet — learners earn one by completing all modules and passing the quiz (4 of 5).',
                        style: TextStyle(height: 1.6, fontSize: 13.5),
                      ),
                    for (final e in certified)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.workspace_premium_rounded,
                                color: AppColors.softYellow, size: 26),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14)),
                                  Text(e.course,
                                      style: const TextStyle(
                                          fontSize: 12.5,
                                          color: AppColors.muted)),
                                ],
                              ),
                            ),
                            Tag(
                                label: 'Score ${e.score}%',
                                color: AppColors.success),
                          ],
                        ),
                      ),
                    const Text('Certificates are verifiable via QR ID.',
                        style: TextStyle(
                            fontSize: 12.5, color: AppColors.muted)),
                  ],
                ),
              );

              if (type != ScreenType.desktop) {
                return Column(
                    children: [dept, const SizedBox(height: 20), certs]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: dept),
                  const SizedBox(width: 20),
                  Expanded(flex: 5, child: certs),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Panel(
            title: 'Individual performance',
            trailing: const Tag(
                label: 'SAMPLE', color: AppColors.warning),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Employee')),
                  DataColumn(label: Text('Department')),
                  DataColumn(label: Text('Course')),
                  DataColumn(label: Text('Progress')),
                  DataColumn(label: Text('Score')),
                  DataColumn(label: Text('Status')),
                ],
                rows: [
                  for (final e in state.roster)
                    DataRow(cells: [
                      DataCell(Text(e.name,
                          style: const TextStyle(fontWeight: FontWeight.w600))),
                      DataCell(Text(e.department)),
                      DataCell(SizedBox(
                          width: 250,
                          child: Text(e.course,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis))),
                      DataCell(Text('${e.progress}%')),
                      DataCell(Text(e.score == 0 ? '—' : '${e.score}%')),
                      DataCell(Tag(
                        label: e.status,
                        color: e.status == 'Completed'
                            ? AppColors.success
                            : e.status == 'Not Started' ||
                                    e.status == 'Invited'
                                ? AppColors.muted
                                : AppColors.indigo,
                      )),
                    ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
