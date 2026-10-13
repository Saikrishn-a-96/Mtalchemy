import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../../widgets/portal_shell.dart';
import 'employer_dashboard_screen.dart';

class AssignCourseScreen extends StatefulWidget {
  const AssignCourseScreen({super.key});

  @override
  State<AssignCourseScreen> createState() => _AssignCourseScreenState();
}

class _AssignCourseScreenState extends State<AssignCourseScreen> {
  String _courseId = Content.courses.first.id;
  final Set<int> _selected = {0, 1};
  String _deadline = '30 October 2026';
  bool _notify = true;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final course =
        Content.courses.firstWhere((c) => c.id == _courseId);
    final departments = <String>{
      for (final e in state.roster) e.department,
    };

    return PortalShell(
      title: 'Corporate course assignment',
      subtitle: 'Select a course, choose employees and set a deadline',
      activeRoute: '/employer/assign',
      items: EmployerDashboardScreen.items,
      child: ResponsiveBuilder(
        builder: (context, type) {
          final picker = Panel(
            title: '1 · Choose a course',
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 560),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final c in Content.courses)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _courseId = c.id),
                    child: AnimatedContainer(
                      duration: 180.ms,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _courseId == c.id
                            ? AppColors.purpleSoft
                            : AppColors.bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _courseId == c.id
                              ? AppColors.purple
                              : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          NetworkImg(
                            url: c.image,
                            width: 50,
                            height: 50,
                            radius: BorderRadius.circular(10),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                                const SizedBox(height: 3),
                                Text('${c.modules} modules · ${c.duration}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.muted)),
                              ],
                            ),
                          ),
                          if (_courseId == c.id)
                            const Icon(Icons.check_circle_rounded,
                                color: AppColors.purple, size: 20),
                        ],
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ),
          );

          final assign = Panel(
            title: '2 · Assign',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select employees',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 14),
                for (final dept in departments) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(dept.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w800,
                            color: AppColors.muted)),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < state.roster.length; i++)
                        if (state.roster[i].department == dept)
                          FilterChip(
                            avatar: CircleAvatar(
                              radius: 10,
                              backgroundColor: AppColors.deepBlue,
                              child: Text(
                                state.roster[i].name.isEmpty
                                    ? '?'
                                    : state.roster[i].name[0],
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            label: Text(state.roster[i].name),
                            selected: _selected.contains(i),
                            selectedColor: AppColors.purpleSoft,
                            checkmarkColor: AppColors.purple,
                            onSelected: (sel) => setState(() {
                              sel ? _selected.add(i) : _selected.remove(i);
                            }),
                          ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
                const Divider(),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Deadline',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5)),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2026, 10, 30),
                                firstDate: DateTime(2026, 10, 12),
                                lastDate: DateTime(2027, 6, 30),
                              );
                              if (picked != null) {
                                setState(() => _deadline =
                                    '${picked.day} ${_month(picked.month)} ${picked.year}');
                              }
                            },
                            icon: const Icon(Icons.calendar_month_rounded,
                                size: 18),
                            label: Text(_deadline),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Notify employees',
                            style: TextStyle(fontSize: 14)),
                        subtitle: const Text('In-app + email',
                            style: TextStyle(fontSize: 12)),
                        value: _notify,
                        onChanged: (v) => setState(() => _notify = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    PrimaryButton(
                      label: 'Assign Course',
                      icon: Icons.send_rounded,
                      onPressed: _selected.isEmpty
                          ? null
                          : () => _confirm(context, course.title),
                    ),
                    const SizedBox(width: 12),
                    Text('${_selected.length} employee(s) selected',
                        style: const TextStyle(
                            fontSize: 13.5, color: AppColors.muted)),
                  ],
                ),
              ],
            ),
          );

          if (type == ScreenType.mobile) {
            return Column(
                children: [picker, const SizedBox(height: 20), assign]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: picker),
              const SizedBox(width: 20),
              Expanded(flex: 7, child: assign),
            ],
          );
        },
      ),
    );
  }

  String _month(int m) => const [
        'January', 'February', 'March', 'April', 'May', 'June', 'July',
        'August', 'September', 'October', 'November', 'December'
      ][m - 1];

  void _confirm(BuildContext context, String courseTitle) {
    final state = AppState.instance;
    final valid =
        _selected.where((i) => i < state.roster.length).toList()..sort();
    if (valid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one employee')),
      );
      return;
    }
    final names = [for (final i in valid) state.roster[i].name];
    state.assignCourse(
        course: courseTitle, employees: names, deadline: _deadline);
    setState(() {
      _selected
        ..clear()
        ..addAll(valid);
    });
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.success),
            SizedBox(width: 10),
            Text('Course assigned'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '“$courseTitle” assigned to ${names.length} employee(s): ${names.join(', ')}.',
              style: const TextStyle(height: 1.6),
            ),
            const SizedBox(height: 10),
            Text('Deadline: $_deadline',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            if (_notify)
              const Text('Employees will receive an in-app notification.',
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/employer/reports');
            },
            child: const Text('View progress'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done'),
          ),
        ],
      ),
    ).then((_) => setState(() {}));
  }
}
