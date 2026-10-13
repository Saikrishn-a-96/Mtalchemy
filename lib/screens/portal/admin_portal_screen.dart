import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../../widgets/portal_shell.dart';

class AdminPortalScreen extends StatefulWidget {
  const AdminPortalScreen({super.key});

  @override
  State<AdminPortalScreen> createState() => _AdminPortalScreenState();
}

class _AdminPortalScreenState extends State<AdminPortalScreen> {
  int _section = 0;

  static const _sections = [
    ('Dashboard', Icons.dashboard_rounded),
    ('Users', Icons.manage_accounts_rounded),
    ('Organizations', Icons.corporate_fare_rounded),
    ('Courses', Icons.menu_book_rounded),
    ('Modules', Icons.view_module_rounded),
    ('Assessments', Icons.quiz_rounded),
    ('Certificates', Icons.workspace_premium_rounded),
    ('Products', Icons.inventory_2_rounded),
    ('Orders', Icons.receipt_long_rounded),
    ('Payments', Icons.payments_rounded),
    ('Inventory', Icons.warehouse_rounded),
    ('Content', Icons.article_rounded),
    ('Testimonials', Icons.format_quote_rounded),
    ('Impact Stories', Icons.auto_awesome_rounded),
    ('Reports', Icons.insights_rounded),
    ('Settings', Icons.settings_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return PortalShell(
      title: _sections[_section].$1,
      subtitle: 'MT Alchemy Admin Portal · full platform access',
      activeRoute: '/admin',
      items: const [
        PortalNavItem('Admin dashboard', Icons.admin_panel_settings_rounded,
            '/admin'),
        PortalNavItem('Learning Hub', Icons.school_rounded, '/upskilling'),
        PortalNavItem('Store', Icons.storefront_rounded, '/store'),
        PortalNavItem('Reports', Icons.insights_rounded, '/employer/reports'),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < _sections.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: Icon(_sections[i].$2,
                          size: 17,
                          color: _section == i
                              ? Colors.white
                              : AppColors.indigo),
                      label: Text(_sections[i].$1),
                      selected: _section == i,
                      selectedColor: AppColors.deepBlue,
                      labelStyle: TextStyle(
                        color: _section == i ? Colors.white : AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (_) => setState(() => _section = i),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          AnimatedSwitcher(
            duration: 320.ms,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(begin: const Offset(0, .03), end: Offset.zero)
                    .animate(anim),
                child: child,
              ),
            ),
            child: _body(),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    switch (_section) {
      case 0:
        return _dashboard();
      case 3:
        return _courseManagement();
      case 7:
        return _productManagement();
      case 8:
        return _orderManagement();
      case 1:
        return _users();
      default:
        return _generic(_sections[_section].$1);
    }
  }

  Widget _dashboard() {
    final tiles = [
      StatTile(
          value: '1,240',
          label: 'Registered users',
          icon: Icons.manage_accounts_rounded,
          accent: AppColors.deepBlue),
      StatTile(
          value: '18',
          label: 'Published courses',
          icon: Icons.menu_book_rounded,
          accent: AppColors.purple),
      StatTile(
          value: '8',
          label: 'Products',
          icon: Icons.inventory_2_rounded,
          accent: AppColors.indigo),
      StatTile(
          value: 'RM 12,480',
          label: 'Revenue (30 days)',
          icon: Icons.payments_rounded,
          accent: AppColors.success),
      StatTile(
          value: '26',
          label: 'Open orders',
          icon: Icons.receipt_long_rounded,
          accent: AppColors.warning),
      StatTile(
          value: '5',
          label: 'Pending enquiries',
          icon: Icons.forum_rounded,
          accent: AppColors.teal),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveBuilder(
          builder: (context, type) {
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
            final workflow = Panel(
              title: 'Key admin workflows',
              child: Column(
                children: const [
                  _Flow(
                      label: 'Course management',
                      steps: 'Draft → Published → Archived',
                      icon: Icons.menu_book_rounded),
                  _Flow(
                      label: 'Product management',
                      steps: 'Add → Price → Stock → Publish',
                      icon: Icons.inventory_2_rounded),
                  _Flow(
                      label: 'Order management',
                      steps: 'Pending → Paid → Processing → Shipped → Delivered',
                      icon: Icons.receipt_long_rounded),
                  _Flow(
                      label: 'Digital order',
                      steps: 'Pending → Paid → Available',
                      icon: Icons.download_rounded),
                ],
              ),
            );
            final activity = Panel(
              title: 'Recent activity',
              child: Column(
                children: [
                  for (final a in const [
                    ('Course published', 'Lead with Clarity · 2h ago', AppColors.success),
                    ('New order #MA1002', 'Team Reflection Cards · 5h ago', AppColors.indigo),
                    ('User registered', 'priya@abcsdn.my · 1d ago', AppColors.purple),
                    ('Enquiry received', 'Corporate Training · 1d ago', AppColors.warning),
                    ('Certificate issued', 'MT-ALC-2026-0147 · 2d ago', AppColors.teal),
                  ])
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: a.$3, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a.$1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                                Text(a.$2,
                                    style: const TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.muted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
            if (type != ScreenType.desktop) {
              return Column(children: [
                workflow,
                const SizedBox(height: 20),
                activity,
              ]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 6, child: workflow),
                const SizedBox(width: 20),
                Expanded(flex: 6, child: activity),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _courseManagement() {
    return Panel(
      title: 'Course management',
      trailing: PrimaryButton(
        label: 'Create course',
        icon: Icons.add_rounded,
        compact: true,
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course editor opens here (Checkpoint 2)'))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Course')),
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Trainer')),
            DataColumn(label: Text('Modules')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: [
            for (var i = 0; i < Content.courses.length; i++)
              DataRow(cells: [
                DataCell(Row(
                  children: [
                    NetworkImg(
                      url: Content.courses[i].image,
                      width: 42,
                      height: 42,
                      radius: BorderRadius.circular(8),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                        width: 260,
                        child: Text(Content.courses[i].title,
                            maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600))),
                  ],
                )),
                DataCell(Text(Content.courses[i].category)),
                DataCell(Text(Content.courses[i].instructor)),
                DataCell(Text('${Content.courses[i].modules}')),
                DataCell(Text('RM${Content.courses[i].price}')),
                DataCell(Tag(
                  label: i % 5 == 4 ? 'Draft' : i % 7 == 6 ? 'Archived' : 'Published',
                  color: i % 5 == 4
                      ? AppColors.warning
                      : i % 7 == 6
                          ? AppColors.muted
                          : AppColors.success,
                )),
                DataCell(Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        tooltip: 'Edit'),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        tooltip: 'Preview'),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete_outline_rounded,
                            size: 18, color: AppColors.danger),
                        tooltip: 'Delete'),
                  ],
                )),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _productManagement() {
    return Panel(
      title: 'Product management',
      trailing: PrimaryButton(
        label: 'Add product',
        icon: Icons.add_rounded,
        compact: true,
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product editor opens here (Checkpoint 2)'))),
      ),
      child: ResponsiveBuilder(
        builder: (context, type) {
          final cards = [
            for (final p in Content.products)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NetworkImg(
                      url: p.image,
                      width: double.infinity,
                      height: 110,
                      radius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 12),
                    Text(p.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 14.5)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Tag(
                            label: p.isDigital ? 'DIGITAL' : 'PHYSICAL',
                            color: p.isDigital
                                ? AppColors.purple
                                : AppColors.teal),
                        const Spacer(),
                        Text('RM${p.price}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.deepBlue)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          p.isDigital ? 'Stock: —' : 'Stock: ${p.stock}',
                          style: const TextStyle(
                              fontSize: 12.5, color: AppColors.muted),
                        ),
                        const Spacer(),
                        const Icon(Icons.toggle_on_rounded,
                            color: AppColors.success, size: 28),
                      ],
                    ),
                  ],
                ),
              ),
          ];

          final cross = type == ScreenType.mobile
              ? 1
              : type == ScreenType.tablet
                  ? 2
                  : 4;
          final rows = <Widget>[];
          for (var i = 0; i < cards.length; i += cross) {
            final chunk = cards.skip(i).take(cross).toList();
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
    );
  }

  Widget _orderManagement() {
    final orders = AppState.instance.orders;
    return Panel(
      title: 'Order management',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Order')),
                DataColumn(label: Text('Customer')),
                DataColumn(label: Text('Products')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Payment')),
                DataColumn(label: Text('Order status')),
                DataColumn(label: Text('Shipping')),
              ],
              rows: [
                for (var i = 0; i < orders.length; i++)
                  DataRow(cells: [
                    DataCell(Text('${orders[i]['id']}',
                        style: const TextStyle(fontWeight: FontWeight.w700))),
                    DataCell(Text(i.isEven ? 'Aisyah Rahman' : 'Daniel Wong')),
                    DataCell(SizedBox(
                        width: 300,
                        child:
                            Text('${orders[i]['items']}', maxLines: 1))),
                    DataCell(Text('${orders[i]['amount']}')),
                    DataCell(Tag(
                        label: '${orders[i]['status']}',
                        color: AppColors.success)),
                    DataCell(Tag(
                      label: i.isEven ? 'Processing' : 'Shipped',
                      color: i.isEven
                          ? AppColors.warning
                          : AppColors.indigo,
                    )),
                    DataCell(Tag(
                        label: i.isEven ? 'Pending' : 'Delivered',
                        color: i.isEven
                            ? AppColors.muted
                            : AppColors.teal)),
                  ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'State machine — Physical: Pending → Paid → Processing → Shipped → Delivered. Digital: Pending → Paid → Available.',
              style: TextStyle(fontSize: 13.5, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _users() {
    return Panel(
      title: 'User management',
      trailing: const Tag(label: '1,240 users', color: AppColors.indigo),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Joined')),
          ],
          rows: [
            for (final u in const [
              ('Aisyah Rahman', 'aisyah@abcsdn.my', 'Individual', 'Active', '10 Sep 2026'),
              ('Daniel Wong', 'daniel@abcsdn.my', 'Individual', 'Active', '02 Sep 2026'),
              ('Priya Nair', 'priya@abcsdn.my', 'Employer', 'Active', '28 Aug 2026'),
              ('Mabel Tan KH', 'mabel@mtalchemy.my', 'Administrator', 'Active', '01 Aug 2026'),
              ('Esther Ng', 'esther@mtalchemy.my', 'Trainer', 'Active', '01 Aug 2026'),
              ('Jason Lee', 'jason@abcsdn.my', 'Individual', 'Invited', '11 Oct 2026'),
            ])
              DataRow(cells: [
                DataCell(Text(u.$1,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(Text(u.$2)),
                DataCell(Tag(
                  label: u.$3,
                  color: u.$3 == 'Administrator'
                      ? AppColors.deepBlue
                      : u.$3 == 'Trainer'
                          ? AppColors.purple
                          : u.$3 == 'Employer'
                              ? AppColors.indigo
                              : AppColors.teal,
                )),
                DataCell(Tag(
                  label: u.$4,
                  color: u.$4 == 'Active'
                      ? AppColors.success
                      : AppColors.warning,
                )),
                DataCell(Text(u.$5)),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _generic(String title) {
    return Panel(
      title: title,
      child: Column(
        children: [
          EmptyState(
            icon: Icons.construction_rounded,
            title: '$title module',
            message:
                'This area is scoped for Checkpoint 2 (core build). The prototype demonstrates the information architecture, navigation and the modules that carry the most workflow value.',
            action: GhostButton(
              label: 'Back to dashboard',
              onPressed: () => setState(() => _section = 0),
            ),
          ),
        ],
      ),
    );
  }
}

class _Flow extends StatelessWidget {
  final String label;
  final String steps;
  final IconData icon;
  const _Flow(
      {required this.label, required this.steps, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.indigo),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 3),
                  Text(steps,
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.muted)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: AppColors.muted),
          ],
        ),
      );
}
