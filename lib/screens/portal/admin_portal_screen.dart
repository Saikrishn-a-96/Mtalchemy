import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/reporting.dart';
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
      case 1:
        return _users();
      case 2:
        return _organizations();
      case 3:
        return _courseManagement();
      case 4:
        return _modules();
      case 5:
        return _assessments();
      case 6:
        return _certificates();
      case 7:
        return _productManagement();
      case 8:
        return _orderManagement();
      case 9:
        return _payments();
      case 10:
        return _inventory();
      case 11:
        return _contentList();
      case 12:
        return _testimonials();
      case 13:
        return _impactStories();
      case 14:
        return _reportsSection();
      default:
        return _settings();
    }
  }

  Widget _dashboard() {
    final state = AppState.instance;
    final published =
        Content.courses.where((c) => state.coursePublishStatus(c.id) == 'Published').length;
    final revenue = Reporting.orderRevenue(state.orders);
    final tiles = [
      StatTile(
          value: '${state.roster.length}',
          label: 'Learners on roster',
          icon: Icons.manage_accounts_rounded,
          accent: AppColors.deepBlue),
      StatTile(
          value: '$published/${Content.courses.length}',
          label: 'Published courses',
          icon: Icons.menu_book_rounded,
          accent: AppColors.purple),
      StatTile(
          value: '${Content.products.length}',
          label: 'Products',
          icon: Icons.inventory_2_rounded,
          accent: AppColors.indigo),
      StatTile(
          value: 'RM${revenue.toStringAsFixed(0)}',
          label: 'Order revenue (sample)',
          icon: Icons.payments_rounded,
          accent: AppColors.success),
      StatTile(
          value: '${state.orders.length}',
          label: 'Orders',
          icon: Icons.receipt_long_rounded,
          accent: AppColors.warning),
      StatTile(
          value: '${state.enquiries.length}',
          label: 'Enquiries received',
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
                children: [
                  _Flow(
                      label: 'Course management',
                      steps: 'Published ↔ Draft · preview each course',
                      icon: Icons.menu_book_rounded,
                      onTap: () => setState(() => _section = 3)),
                  _Flow(
                      label: 'Product management',
                      steps: 'Adjust stock from this portal',
                      icon: Icons.inventory_2_rounded,
                      onTap: () => setState(() => _section = 7)),
                  _Flow(
                      label: 'Order management',
                      steps: 'Advance Paid → Shipped → Delivered',
                      icon: Icons.receipt_long_rounded,
                      onTap: () => setState(() => _section = 8)),
                  _Flow(
                      label: 'Digital order',
                      steps: 'Paid → Available in the library',
                      icon: Icons.download_rounded,
                      onTap: () => setState(() => _section = 8)),
                ],
              ),
            );
            final activity = Panel(
              title: 'Recent activity',
              trailing:
                  const Tag(label: 'SAMPLE', color: AppColors.warning),
              child: Column(
                children: [
                  for (final a in _recentActivity())
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

  /// Activity feed derived from live prototype state (orders,
  /// enquiries, assignments, roster) — sample data, newest first.
  List<(String, String, Color)> _recentActivity() {
    final state = AppState.instance;
    final items = <(String, String, Color)>[];
    for (final o in state.orders.take(2)) {
      items.add((
        'Order ${o['id']} · ${o['status']}',
        '${o['items']} · ${o['date']}',
        AppColors.indigo
      ));
    }
    for (final e in state.enquiries.take(2)) {
      items.add((
        'Enquiry · ${e['type']}',
        '${e['name']} · ${e['date']}',
        AppColors.warning
      ));
    }
    for (final a in state.assignments.take(1)) {
      items.add((
        'Course assigned',
        '${a['course']} · due ${a['deadline']}',
        AppColors.success
      ));
    }
    items.add((
      'Roster update',
      '${state.roster.length} learners · ${state.roster.where((e) => e.progress >= 100).length} completed',
      AppColors.teal
    ));
    return items;
  }

  Widget _courseManagement() {
    final state = AppState.instance;
    return Panel(
      title: 'Course management',
      trailing: const Tag(label: 'SAMPLE', color: AppColors.warning),
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
            for (final c in Content.courses)
              DataRow(cells: [
                DataCell(Row(
                  children: [
                    NetworkImg(
                      url: c.image,
                      width: 42,
                      height: 42,
                      radius: BorderRadius.circular(8),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                        width: 260,
                        child: Text(c.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600))),
                  ],
                )),
                DataCell(Text(c.category)),
                DataCell(Text(c.instructor)),
                DataCell(Text('${c.modules}')),
                DataCell(Text('RM${c.price}')),
                DataCell(Tag(
                  label: state.coursePublishStatus(c.id),
                  color: state.coursePublishStatus(c.id) == 'Published'
                      ? AppColors.success
                      : AppColors.warning,
                )),
                DataCell(Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pushNamed(
                            context, '/course',
                            arguments: c),
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        tooltip: 'Preview public page'),
                    IconButton(
                        onPressed: () => state.toggleCourseStatus(c.id),
                        icon: const Icon(Icons.published_with_changes_rounded,
                            size: 18),
                        tooltip: 'Toggle Published / Draft'),
                  ],
                )),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _productManagement() {
    final state = AppState.instance;
    return Panel(
      title: 'Product management',
      trailing: const Tag(label: 'SAMPLE', color: AppColors.warning),
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
                          p.isDigital
                              ? 'Stock: digital (unlimited)'
                              : 'Stock: ${state.effectiveStock(p)}',
                          style: const TextStyle(
                              fontSize: 12.5, color: AppColors.muted),
                        ),
                        const Spacer(),
                        if (!p.isDigital) ...[
                          InkWell(
                            onTap: () => state.adjustStock(p, -1),
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.remove_circle_outline_rounded,
                                  size: 22, color: AppColors.indigo),
                            ),
                          ),
                          InkWell(
                            onTap: () => state.adjustStock(p, 1),
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.add_circle_outline_rounded,
                                  size: 22, color: AppColors.indigo),
                            ),
                          ),
                        ] else
                          const Icon(Icons.all_inclusive_rounded,
                              color: AppColors.success, size: 24),
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
    final state = AppState.instance;
    final orders = state.orders;
    return Panel(
      title: 'Order management',
      trailing: Tag(
          label: '${orders.length} orders', color: AppColors.indigo),
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
                DataColumn(label: Text('Fulfilment')),
                DataColumn(label: Text('Advance')),
              ],
              rows: [
                for (final o in orders)
                  DataRow(cells: [
                    DataCell(Text('${o['id']}',
                        style: const TextStyle(fontWeight: FontWeight.w700))),
                    DataCell(Text('${o['customer'] ?? '—'}')),
                    DataCell(SizedBox(
                        width: 300,
                        child: Text('${o['items']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis))),
                    DataCell(Text('${o['amount']}')),
                    DataCell(const Tag(
                        label: 'Paid', color: AppColors.success)),
                    DataCell(Tag(
                      label: '${o['status']}',
                      color: '${o['status']}' == 'Delivered' ||
                              '${o['status']}' == 'Available'
                          ? AppColors.teal
                          : AppColors.warning,
                    )),
                    DataCell(
                      Builder(builder: (context) {
                        final done = '${o['status']}' == 'Delivered' ||
                            '${o['status']}' == 'Available';
                        return TextButton(
                          onPressed: done
                              ? null
                              : () {
                                  state.advanceOrderStatus(o);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                              '${o['id']} → ${o['status']}')));
                                },
                          child: Text(done ? 'Done' : 'Advance'),
                        );
                      }),
                    ),
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
              'State machine — physical goods: Paid → Shipped → Delivered. Digital goods: Paid → Available in the library.',
              style: TextStyle(fontSize: 13.5, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _users() {
    final roster = AppState.instance.roster;
    return Panel(
      title: 'User management',
      trailing: Tag(
          label: '${roster.length} users (sample)',
          color: AppColors.indigo),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Progress')),
          ],
          rows: [
            for (final u in roster)
              DataRow(cells: [
                DataCell(Text(u.name,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(Text(u.email.isEmpty ? '—' : u.email)),
                DataCell(Tag(
                  label: u.role,
                  color: u.role == 'Administrator'
                      ? AppColors.deepBlue
                      : u.role == 'Trainer'
                          ? AppColors.purple
                          : u.role == 'Department Lead'
                              ? AppColors.indigo
                              : AppColors.teal,
                )),
                DataCell(Tag(
                  label: u.status,
                  color: u.status == 'Completed'
                      ? AppColors.success
                      : u.status == 'Invited' || u.status == 'Not Started'
                          ? AppColors.muted
                          : AppColors.indigo,
                )),
                DataCell(Text('${u.progress}%')),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _organizations() {
    final state = AppState.instance;
    return Panel(
      title: 'Organizations',
      trailing: const Tag(label: 'SAMPLE', color: AppColors.warning),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.corporate_fare_rounded,
                    size: 34, color: AppColors.deepBlue),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ABC Sdn Bhd',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 17)),
                      SizedBox(height: 4),
                      Text(
                        'Sample client organization · FY2026 learning programme · plan: Corporate',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
                Tag(label: 'ACTIVE', color: AppColors.success),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                  child: StatTile(
                      value: '${state.roster.length}',
                      label: 'Learners',
                      icon: Icons.groups_rounded,
                      accent: AppColors.deepBlue)),
              const SizedBox(width: 14),
              Expanded(
                  child: StatTile(
                      value: '${state.assignments.length}',
                      label: 'Assignments',
                      icon: Icons.assignment_rounded,
                      accent: AppColors.purple)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _modules() {
    return Panel(
      title: 'Modules',
      trailing: Text(
          '${Content.courses.fold(0, (s, c) => s + c.modules)} modules in catalogue',
          style: const TextStyle(
              color: AppColors.muted, fontWeight: FontWeight.w600)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Course')),
            DataColumn(label: Text('Modules')),
            DataColumn(label: Text('Lessons listed')),
            DataColumn(label: Text('Duration')),
          ],
          rows: [
            for (final c in Content.courses)
              DataRow(cells: [
                DataCell(SizedBox(
                    width: 260,
                    child: Text(c.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)))),
                DataCell(Text('${c.modules}')),
                DataCell(Text('${c.curriculum.length}')),
                DataCell(Text(c.duration)),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _assessments() {
    return Panel(
      title: 'Assessments',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.quiz_rounded,
                    size: 30, color: AppColors.purple),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'End-of-course quiz · ${Content.quiz.length} questions · pass mark 4 of ${Content.quiz.length} (80%) · passing unlocks the certificate.',
                    style: const TextStyle(height: 1.6, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Preview quiz',
            icon: Icons.play_arrow_rounded,
            compact: true,
            onPressed: () => Navigator.pushNamed(context, '/quiz'),
          ),
        ],
      ),
    );
  }

  Widget _certificates() {
    final state = AppState.instance;
    final issued =
        state.roster.where((e) => e.progress >= 100).toList();
    return Panel(
      title: 'Certificates',
      trailing: Tag(
          label: '${issued.length} issued', color: AppColors.success),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Issued when a learner completes all modules and passes the quiz (4 of 5). Verify any certificate by its QR ID on the certificate page.',
            style: TextStyle(fontSize: 13.5, height: 1.6),
          ),
          const SizedBox(height: 14),
          if (issued.isEmpty)
            const Text('No certificates issued yet.',
                style: TextStyle(color: AppColors.muted)),
          for (final e in issued)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium_rounded,
                      color: AppColors.softYellow),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('${e.name} — ${e.course}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                  Tag(
                      label: 'Score ${e.score}%',
                      color: AppColors.success),
                ],
              ),
            ),
          const SizedBox(height: 8),
          GhostButton(
            label: 'Open certificate page',
            compact: true,
            onPressed: () =>
                Navigator.pushNamed(context, '/certificate'),
          ),
        ],
      ),
    );
  }

  Widget _payments() {
    final state = AppState.instance;
    final revenue = Reporting.orderRevenue(state.orders);
    return Panel(
      title: 'Payments',
      trailing: const Tag(label: 'SAMPLE', color: AppColors.warning),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Collected revenue: RM${revenue.toStringAsFixed(2)} across ${state.orders.length} order(s). Payments are simulated in this prototype — no gateway is connected.',
            style: const TextStyle(height: 1.6, fontSize: 14),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Order')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Customer')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Status')),
              ],
              rows: [
                for (final o in state.orders)
                  DataRow(cells: [
                    DataCell(Text('${o['id']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700))),
                    DataCell(Text('${o['date']}')),
                    DataCell(Text('${o['customer'] ?? '—'}')),
                    DataCell(Text('${o['amount']}')),
                    DataCell(Tag(
                        label: '${o['status']}',
                        color: AppColors.success)),
                  ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inventory() {
    final low = Content.products.where((p) => !p.isDigital).toList();
    return Panel(
      title: 'Inventory',
      trailing: const Tag(label: 'SAMPLE', color: AppColors.warning),
      child: Column(
        children: [
          for (final p in low)
            Builder(builder: (context) {
              final stock = AppState.instance.effectiveStock(p);
              final isLow = stock <= 10;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    NetworkImg(
                        url: p.image,
                        width: 44,
                        height: 44,
                        radius: BorderRadius.circular(10)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14)),
                          Text('SKU ${p.id.toUpperCase()} · ${p.category}',
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.muted)),
                        ],
                      ),
                    ),
                    Tag(
                        label: isLow
                            ? 'LOW · $stock left'
                            : '$stock in stock',
                        color: isLow
                            ? AppColors.danger
                            : AppColors.success),
                  ],
                ),
              );
            }),
          const Text(
            'Digital goods are unlimited. Adjust physical stock from Product management.',
            style: TextStyle(fontSize: 12.5, color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _contentList() {
    return Panel(
      title: 'Content library',
      trailing: Text('${Content.insights.length} insights',
          style: const TextStyle(
              color: AppColors.muted, fontWeight: FontWeight.w600)),
      child: Column(
        children: [
          for (final i in Content.insights)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(i.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('${i.category} · ${i.readTime}',
                            style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.muted)),
                      ],
                    ),
                  ),
                  Tag(label: i.category, color: AppColors.indigo),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _testimonials() {
    return Panel(
      title: 'Testimonials',
      trailing: const Tag(label: 'SAMPLE', color: AppColors.warning),
      child: Column(
        children: [
          for (final t in Content.testimonials)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('“${t['quote']}”',
                      style: const TextStyle(
                          height: 1.6, fontSize: 13.5)),
                  const SizedBox(height: 8),
                  Text('${t['name']} · ${t['org']}',
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.muted)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _impactStories() {
    final total = Content.stories
        .fold(0, (sum, s) => sum + s.participants);
    return Panel(
      title: 'Impact stories',
      trailing: Tag(
          label: '$total participants', color: AppColors.success),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Programme')),
            DataColumn(label: Text('Audience')),
            DataColumn(label: Text('Participants')),
            DataColumn(label: Text('Outcome')),
          ],
          rows: [
            for (final s in Content.stories)
              DataRow(cells: [
                DataCell(SizedBox(
                    width: 220,
                    child: Text(s.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)))),
                DataCell(Text(s.clientType)),
                DataCell(Text('${s.participants}')),
                DataCell(SizedBox(
                    width: 320,
                    child: Text(s.outcome,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis))),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _reportsSection() {
    final state = AppState.instance;
    final stats = Reporting.reportStats(state.roster);
    return Panel(
      title: 'Reports',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${stats.enrolments} enrolments · ${stats.completions} completions (${stats.completionRate}%) · average score ${stats.averageScore}% · ${stats.learningHours}h assigned.',
            style: const TextStyle(height: 1.7, fontSize: 14),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Open learning reports',
            icon: Icons.insights_rounded,
            compact: true,
            onPressed: () =>
                Navigator.pushNamed(context, '/employer/reports'),
          ),
        ],
      ),
    );
  }

  Widget _settings() {
    final state = AppState.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Panel(
          title: 'Session',
          child: Row(
            children: [
              const Icon(Icons.admin_panel_settings_rounded,
                  color: AppColors.deepBlue, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.userName ?? 'Guest visitor',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 15)),
                    Text(state.userRole,
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 13)),
                  ],
                ),
              ),
              GhostButton(
                label: 'Sign out',
                compact: true,
                onPressed: () {
                  state.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (r) => false);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Panel(
          title: 'Notifications (prototype)',
          child: Column(
            children: [
              for (final key in state.adminSwitches.keys)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(key, style: const TextStyle(fontSize: 14)),
                  value: state.adminSwitches[key] ?? false,
                  onChanged: (v) {
                    state.setAdminSwitch(key, v);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '$key ${v ? 'enabled' : 'disabled'}')),
                    );
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Panel(
          title: 'Prototype data',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${Content.courses.length} courses · ${Content.products.length} products · ${state.roster.length} learners · ${state.orders.length} orders · ${state.enquiries.length} enquiries. All figures on this portal are computed from this sample dataset.',
                style: const TextStyle(height: 1.7, fontSize: 13.5),
              ),
              const SizedBox(height: 14),
              GhostButton(
                label: 'Back to website',
                compact: true,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/', (r) => false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Flow extends StatelessWidget {
  final String label;
  final String steps;
  final IconData icon;
  final VoidCallback? onTap;
  const _Flow(
      {required this.label,
      required this.steps,
      required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
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
        ),
      );
}
