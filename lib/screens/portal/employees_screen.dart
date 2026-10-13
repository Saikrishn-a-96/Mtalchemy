import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../../widgets/portal_shell.dart';
import 'employer_dashboard_screen.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  String _dept = 'Human Resources';
  String _role = 'Learner';

  static const _departments = [
    'Human Resources',
    'Finance',
    'Operations',
    'Sales',
    'Marketing',
    'IT',
  ];

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  void _add() {
    if (!_formKey.currentState!.validate()) return;
    final state = AppState.instance;
    if (state.roster
        .any((e) => e.email.toLowerCase() == _email.text.trim().toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('That email is already on the roster')),
      );
      return;
    }
    state.addEmployee(
        _name.text.trim(), _dept, _email.text.trim(),
        role: _role);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invitation sent to ${_email.text.trim()}')),
    );
    _name.clear();
    _email.clear();
    _formKey.currentState!.reset();
  }

  void _confirmRemove(String name, String email) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remove employee?'),
        content: Text(
          '$name will be removed from the roster and excluded from reports. This only affects this prototype session.',
          style: const TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              AppState.instance.removeEmployee(email);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name removed from the roster')),
              );
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _bulkImport() {
    final controller = TextEditingController();
    String? error;
    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Bulk import (CSV)'),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Paste one employee per line as:  Full name, work email, Department',
                  style: TextStyle(fontSize: 13.5, height: 1.5),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText:
                        'Aina Lim, aina@abcsdn.my, Marketing\nRavi Kumar, ravi@abcsdn.my, IT',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (error != null) ...[
                  const SizedBox(height: 10),
                  Text(error!,
                      style: const TextStyle(
                          color: AppColors.danger, fontSize: 13)),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final state = AppState.instance;
                final emailRe =
                    RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
                var added = 0;
                final problems = <String>[];
                final lines = controller.text.split('\n');
                for (var i = 0; i < lines.length; i++) {
                  final line = lines[i].trim();
                  if (line.isEmpty) continue;
                  final parts =
                      line.split(',').map((p) => p.trim()).toList();
                  if (parts.length != 3 ||
                      parts[0].isEmpty ||
                      !emailRe.hasMatch(parts[1]) ||
                      parts[2].isEmpty) {
                    problems.add('Line ${i + 1}: expected “Name, email, Department”');
                    continue;
                  }
                  if (state.roster.any((e) =>
                      e.email.toLowerCase() == parts[1].toLowerCase())) {
                    problems.add('Line ${i + 1}: already on the roster');
                    continue;
                  }
                  state.addEmployee(parts[0], parts[2], parts[1]);
                  added++;
                }
                if (added == 0 && problems.isEmpty) {
                  setDialogState(() =>
                      error = 'Paste at least one employee line first.');
                  return;
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(problems.isEmpty
                          ? '$added employee(s) added'
                          : '$added added · ${problems.length} skipped (${problems.first})')),
                );
              },
              child: const Text('Import'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return PortalShell(
      title: 'Employee management',
      subtitle: 'Add, invite and track learners in your organization',
      activeRoute: '/employer/employees',
      items: EmployerDashboardScreen.items,
      child: ResponsiveBuilder(
        builder: (context, type) {
          final form = Panel(
            title: 'Add an employee',
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Send a learning invitation by email. The employee joins the roster below and appears in reports automatically.',
                      style: TextStyle(fontSize: 13.5, height: 1.6)),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Full name *',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Work email *',
                      hintText: 'name@abcsdn.my',
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email address is required';
                      }
                      if (!RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$')
                          .hasMatch(v.trim())) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _dept,
                    decoration: const InputDecoration(
                      labelText: 'Department *',
                      prefixIcon: Icon(Icons.business_rounded),
                    ),
                    items: [
                      for (final d in _departments)
                        DropdownMenuItem(value: d, child: Text(d)),
                    ],
                    onChanged: (v) => setState(() => _dept = v!),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _role,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Learner', child: Text('Learner')),
                      DropdownMenuItem(
                          value: 'Department Lead',
                          child: Text('Department Lead')),
                    ],
                    onChanged: (v) => setState(() => _role = v ?? 'Learner'),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      PrimaryButton(
                        label: 'Add employee',
                        icon: Icons.person_add_alt_1_rounded,
                        onPressed: _add,
                      ),
                      GhostButton(
                        label: 'Bulk import CSV',
                        compact: true,
                        onPressed: _bulkImport,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );

          final table = Panel(
            title: 'Employees',
            trailing: Tag(
                label: '${state.roster.length} active',
                color: AppColors.success),
            child: state.roster.isEmpty
                ? const EmptyState(
                    icon: Icons.groups_outlined,
                    title: 'No employees yet',
                    message:
                        'Add your first employee with the form to start assigning courses.',
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Employee')),
                        DataColumn(label: Text('Department')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Learning status')),
                        DataColumn(label: Text('Action')),
                      ],
                      rows: [
                        for (final e in state.roster)
                          DataRow(cells: [
                            DataCell(Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: AppColors.purpleSoft,
                                  child: Text(
                                    e.name.isEmpty ? '?' : e.name[0],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13,
                                        color: AppColors.purple),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(e.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ],
                            )),
                            DataCell(Text(e.department)),
                            DataCell(Text(e.email.isEmpty ? '—' : e.email)),
                            DataCell(Tag(
                              label: e.status,
                              color: e.status == 'Completed'
                                  ? AppColors.success
                                  : e.status == 'Not Started' ||
                                          e.status == 'Invited'
                                      ? AppColors.muted
                                      : AppColors.indigo,
                            )),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  tooltip: 'Assign course',
                                  onPressed: () => Navigator.pushNamed(
                                      context, '/employer/assign'),
                                  icon: const Icon(Icons.assignment_outlined,
                                      size: 19),
                                ),
                                IconButton(
                                  tooltip: 'Remove',
                                  onPressed: () =>
                                      _confirmRemove(e.name, e.email),
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      size: 19, color: AppColors.danger),
                                ),
                              ],
                            )),
                          ]),
                      ],
                    ),
                  ),
          );

          if (type != ScreenType.desktop) {
            return Column(
                children: [form, const SizedBox(height: 20), table]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 360, child: form),
              const SizedBox(width: 20),
              Expanded(child: table),
            ],
          );
        },
      ),
    );
  }
}
