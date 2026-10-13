import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../../widgets/portal_shell.dart';

class EmployerDashboardScreen extends StatelessWidget {
  const EmployerDashboardScreen({super.key});

  static const items = [
    PortalNavItem('Dashboard', Icons.dashboard_rounded, '/employer'),
    PortalNavItem('Employee management', Icons.groups_rounded,
        '/employer/employees'),
    PortalNavItem('Assign course', Icons.assignment_rounded,
        '/employer/assign'),
    PortalNavItem('Learning reports', Icons.insights_rounded,
        '/employer/reports'),
    PortalNavItem('Learning Hub', Icons.school_rounded, '/upskilling'),
    PortalNavItem('Purchase courses', Icons.storefront_rounded, '/store'),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return PortalShell(
      title: 'Employer / Corporate Dashboard',
      subtitle: 'Organization: ABC Sdn Bhd · FY2026 learning programme',
      activeRoute: '/employer',
      items: items,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveBuilder(
            builder: (context, type) {
              final tiles = [
                StatTile(
                    value: '${state.myEmployees.length}',
                    label: 'Total employees',
                    icon: Icons.groups_rounded,
                    accent: AppColors.deepBlue),
                StatTile(
                    value: '3',
                    label: 'Active learners',
                    icon: Icons.school_rounded,
                    accent: AppColors.purple),
                StatTile(
                    value: '4',
                    label: 'Courses assigned',
                    icon: Icons.assignment_rounded,
                    accent: AppColors.indigo),
                StatTile(
                    value: '62%',
                    label: 'Completion rate',
                    icon: Icons.trending_up_rounded,
                    accent: AppColors.success),
                StatTile(
                    value: '2',
                    label: 'Certificates earned',
                    icon: Icons.workspace_premium_rounded,
                    accent: AppColors.softYellow),
                StatTile(
                    value: '48h',
                    label: 'Learning hours',
                    icon: Icons.schedule_rounded,
                    accent: AppColors.teal),
              ];
              final cross = type == ScreenType.mobile
                  ? 1
                  : type == ScreenType.tablet
                      ? 2
                      : 3;
              final rows = <Widget>[];
              for (var i = 0; i < tiles.length; i += cross) {
                final chunk = tiles.skip(i).take(cross).toList();
                rows.add(Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var j = 0; j < chunk.length; j++) ...[
                        if (j > 0) const SizedBox(width: 16),
                        Expanded(child: chunk[j]),
                      ],
                      if (chunk.length < cross)
                        for (var k = chunk.length; k < cross; k++)
                          const Expanded(child: SizedBox()),
                    ],
                  ),
                ));
              }
              return Column(children: rows);
            },
          ),
          ResponsiveBuilder(
            builder: (context, type) {
              final progress = Panel(
                title: 'Department progress',
                trailing: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/employer/reports'),
                  child: const Text('Full report'),
                ),
                child: Column(
                  children: [
                    for (final d in const [
                      ('Human Resources', 0.9, '90%'),
                      ('Finance', 1.0, '100%'),
                      ('Operations', 0.45, '45%'),
                      ('Sales', 0.1, '10%'),
                    ])
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
                                const Spacer(),
                                Text(d.$3,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13.5,
                                        color: AppColors.deepBlue)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: d.$2),
                              duration: 900.ms,
                              curve: Curves.easeOutCubic,
                              builder: (context, v, _) =>
                                  ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value: v,
                                  minHeight: 9,
                                  backgroundColor: AppColors.border,
                                  valueColor:
                                      const AlwaysStoppedAnimation(
                                          AppColors.purple),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );

              final side = Column(
                children: [
                  Panel(
                    title: 'Quick actions',
                    child: Column(
                      children: [
                        _Action(
                            icon: Icons.person_add_alt_1_rounded,
                            label: 'Add Employee',
                            onTap: () => Navigator.pushNamed(
                                context, '/employer/employees')),
                        _Action(
                            icon: Icons.assignment_rounded,
                            label: 'Assign Course',
                            onTap: () => Navigator.pushNamed(
                                context, '/employer/assign')),
                        _Action(
                            icon: Icons.insights_rounded,
                            label: 'View Reports',
                            onTap: () => Navigator.pushNamed(
                                context, '/employer/reports')),
                        _Action(
                            icon: Icons.shopping_cart_rounded,
                            label: 'Purchase Courses',
                            onTap: () =>
                                Navigator.pushNamed(context, '/store')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Panel(
                    title: 'Pending assignments',
                    child: Column(
                      children: [
                        for (final a in const [
                          ('Workplace Well-being Practitioner', 'Due 30 Oct 2026', '2 pending'),
                          ('Communicate with Impact', 'Due 05 Nov 2026', '1 pending'),
                        ])
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.bg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a.$1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(a.$2,
                                        style: const TextStyle(
                                            fontSize: 12.5,
                                            color: AppColors.muted)),
                                    const Spacer(),
                                    Tag(
                                        label: a.$3,
                                        color: AppColors.warning),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );

              if (type != ScreenType.desktop) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(children: [progress, const SizedBox(height: 20), side]),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: progress),
                    const SizedBox(width: 20),
                    Expanded(flex: 5, child: side),
                  ],
                ),
              );
            },
          ),
          Panel(
            title: 'Team roster',
            trailing: TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/employer/employees'),
              child: const Text('Manage'),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Employee')),
                  DataColumn(label: Text('Department')),
                  DataColumn(label: Text('Course')),
                  DataColumn(label: Text('Progress')),
                  DataColumn(label: Text('Status')),
                ],
                rows: [
                  for (final e in Content.employees)
                    DataRow(cells: [
                      DataCell(Text(e.name,
                          style:
                              const TextStyle(fontWeight: FontWeight.w600))),
                      DataCell(Text(e.department)),
                      DataCell(SizedBox(
                          width: 260,
                          child: Text(e.course, maxLines: 1))),
                      DataCell(SizedBox(
                        width: 140,
                        child: Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value: e.progress / 100,
                                  minHeight: 7,
                                  backgroundColor: AppColors.border,
                                  valueColor: AlwaysStoppedAnimation(
                                    e.progress == 100
                                        ? AppColors.success
                                        : AppColors.purple,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${e.progress}%',
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      )),
                      DataCell(Tag(
                          label: e.status,
                          color: e.status == 'Completed'
                              ? AppColors.success
                              : e.status == 'Not Started'
                                  ? AppColors.muted
                                  : AppColors.indigo)),
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

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _Action(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.indigo),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14.5)),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 13, color: AppColors.muted),
            ],
          ),
        ),
      );
}
