import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../../widgets/portal_shell.dart';
import 'employer_dashboard_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  static const _deptData = [
    ('Human Resources', 0.9, '90%', '4 learners'),
    ('Finance', 1.0, '100%', '2 learners'),
    ('Operations', 0.45, '45%', '3 learners'),
    ('Sales', 0.1, '10%', '2 learners'),
  ];

  @override
  Widget build(BuildContext context) {

    return PortalShell(
      title: 'Corporate learning reports',
      subtitle: 'Overall, department and individual performance · export ready',
      activeRoute: '/employer/reports',
      items: EmployerDashboardScreen.items,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Reporting period: 1 Sep – 12 Oct 2026',
                    style: TextStyle(
                        color: AppColors.muted, fontWeight: FontWeight.w600)),
              ),
              PrimaryButton(
                label: 'Export PDF',
                icon: Icons.picture_as_pdf_outlined,
                compact: true,
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generating PDF report…'))),
              ),
              const SizedBox(width: 10),
              GhostButton(
                label: 'Export Excel/CSV',
                compact: true,
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generating CSV report…'))),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ResponsiveBuilder(
            builder: (context, type) {
              final tiles = [
                StatTile(
                    value: '11',
                    label: 'Enrolments',
                    icon: Icons.menu_book_rounded,
                    accent: AppColors.deepBlue),
                StatTile(
                    value: '7',
                    label: 'Completions',
                    icon: Icons.check_rounded,
                    accent: AppColors.success),
                StatTile(
                    value: '86%',
                    label: 'Average score',
                    icon: Icons.grade_rounded,
                    accent: AppColors.softYellow),
                StatTile(
                    value: '48h',
                    label: 'Learning hours',
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
                child: Column(
                  children: [
                    for (final d in _deptData)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(d.$1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                                const SizedBox(width: 10),
                                Text(d.$4,
                                    style: const TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.muted)),
                                const Spacer(),
                                Text(d.$3,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.deepBlue)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: d.$2),
                              duration: 900.ms,
                              curve: Curves.easeOutCubic,
                              builder: (context, v, _) => ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value: v,
                                  minHeight: 10,
                                  backgroundColor: AppColors.border,
                                  valueColor: AlwaysStoppedAnimation(
                                    d.$2 >= 1
                                        ? AppColors.success
                                        : AppColors.purple,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );

              final certs = Panel(
                title: 'Certificates earned',
                child: Column(
                  children: [
                    for (final e in Content.employees
                        .where((e) => e.progress == 100))
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
                            Tag(label: 'MT-ALC-2026', color: AppColors.success),
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
                  for (var i = 0; i < Content.employees.length; i++)
                    DataRow(cells: [
                      DataCell(Text(Content.employees[i].name,
                          style: const TextStyle(fontWeight: FontWeight.w600))),
                      DataCell(Text(Content.employees[i].department)),
                      DataCell(SizedBox(
                          width: 250,
                          child: Text(Content.employees[i].course,
                              maxLines: 1))),
                      DataCell(Text('${Content.employees[i].progress}%')),
                      DataCell(Text(Content.employees[i].progress == 0
                          ? '—'
                          : '${70 + (i * 5) % 30}%')),
                      DataCell(Tag(
                        label: Content.employees[i].status,
                        color: Content.employees[i].status == 'Completed'
                            ? AppColors.success
                            : Content.employees[i].status == 'Not Started'
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
