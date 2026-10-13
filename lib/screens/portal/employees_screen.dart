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
    AppState.instance
        .addEmployee(_name.text.trim(), _dept, _email.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invitation sent to ${_email.text.trim()}')),
    );
    _name.clear();
    _email.clear();
    _formKey.currentState!.reset();
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
                  const Text('Send a learning invitation by email. The employee completes registration and appears in your roster automatically.',
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
                    initialValue: 'Learner',
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
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      PrimaryButton(
                        label: 'Add employee',
                        icon: Icons.person_add_alt_1_rounded,
                        onPressed: _add,
                      ),
                      const SizedBox(width: 12),
                      GhostButton(
                        label: 'Bulk import CSV',
                        compact: true,
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Text(
                                    'CSV import is planned for Checkpoint 2'))),
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
                label: '${state.myEmployees.length} active',
                color: AppColors.success),
            child: SingleChildScrollView(
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
                  for (var i = 0; i < state.myEmployees.length; i++)
                    DataRow(cells: [
                      DataCell(Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColors.purpleSoft,
                            child: Text(
                              state.myEmployees[i]['name']![0],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  color: AppColors.purple),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(state.myEmployees[i]['name']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                        ],
                      )),
                      DataCell(Text(state.myEmployees[i]['dept']!)),
                      DataCell(Text(state.myEmployees[i]['email']!)),
                      DataCell(Tag(
                        label: i.isEven ? 'In Progress' : 'Assigned',
                        color: i.isEven
                            ? AppColors.indigo
                            : AppColors.warning,
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
                            onPressed: () => ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                    content: Text(
                                        'Remove ${state.myEmployees[i]['name']}? (demo)'))),
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
