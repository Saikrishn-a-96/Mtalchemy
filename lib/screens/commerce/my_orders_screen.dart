import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    if (state.orders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 70),
        child: EmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'No orders yet',
          message: 'When you buy courses or products they will appear here.',
          action: PrimaryButton(
              label: 'Browse the store',
              onPressed: () => Navigator.pushNamed(context, '/store')),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('My orders',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text('${state.orders.length} orders · click a row for details',
                            style: const TextStyle(color: AppColors.muted)),
                      ],
                    ),
                  ),
                  GhostButton(
                    label: 'Digital library',
                    compact: true,
                    onPressed: () =>
                        Navigator.pushNamed(context, '/digital-library'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Panel(
                child: ResponsiveBuilder(
                  builder: (context, type) {
                    if (type == ScreenType.mobile) {
                      return Column(
                        children: [
                          for (final o in state.orders)
                            Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.bg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('${o['id']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800)),
                                      const Spacer(),
                                      StatusChip(status: '${o['status']}'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text('${o['items']}',
                                      style: const TextStyle(fontSize: 13.5)),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text('${o['date']}',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.muted)),
                                      const Spacer(),
                                      Text('${o['amount']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                            AppColors.bg),
                        columns: const [
                          DataColumn(label: Text('Order')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Items')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: [
                          for (final o in state.orders)
                            DataRow(cells: [
                              DataCell(Text('${o['id']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700))),
                              DataCell(Text('${o['date']}')),
                              DataCell(SizedBox(
                                  width: 340,
                                  child:
                                      Text('${o['items']}', maxLines: 1))),
                              DataCell(Text('${o['amount']}')),
                              DataCell(StatusChip(status: '${o['status']}')),
                              DataCell(TextButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, '/digital-library'),
                                child: const Text('View'),
                              )),
                            ]),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.purpleSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_rounded, color: AppColors.purple),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Physical orders move through Pending → Paid → Processing → Shipped → Delivered. Digital orders unlock as soon as payment succeeds.',
                        style: TextStyle(fontSize: 13.5, height: 1.55),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  Color get _color => switch (status) {
        'Paid' => AppColors.success,
        'Shipped' => AppColors.indigo,
        'Delivered' => AppColors.teal,
        'Pending' => AppColors.warning,
        _ => AppColors.muted,
      };

  @override
  Widget build(BuildContext context) => Tag(label: status, color: _color);
}
