import 'package:flutter/material.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  static List<Map<String, dynamic>> _linesOf(Map<String, dynamic> order) {
    final lines = order['lines'];
    if (lines is List) {
      return lines.whereType<Map>().map((m) => {
            'name': '${m['name']}',
            'qty': m['qty'] is int ? m['qty'] as int : 1,
            'digital': m['digital'] == true,
          }).toList();
    }
    return [];
  }

  static bool _hasDigital(Map<String, dynamic> order) =>
      _linesOf(order).any((l) => l['digital'] == true);

  void _showDetail(BuildContext context, Map<String, dynamic> order) {
    final lines = _linesOf(order);
    final digital = _hasDigital(order);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Order ${order['id']}'),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusChip(status: '${order['status']}'),
                  Tag(
                      label: '${order['type'] ?? 'mixed'}',
                      color: AppColors.indigo),
                ],
              ),
              const SizedBox(height: 14),
              Text('${order['date']} · ${order['customer'] ?? '—'}',
                  style: const TextStyle(
                      color: AppColors.muted, fontSize: 13)),
              const Divider(height: 28),
              for (final l in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Icon(
                          l['digital'] == true
                              ? Icons.download_rounded
                              : Icons.inventory_2_outlined,
                          size: 18,
                          color: AppColors.indigo),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text('${l['name']} ×${l['qty']}',
                              style:
                                  const TextStyle(fontSize: 14))),
                    ],
                  ),
                ),
              const Divider(height: 28),
              Row(
                children: [
                  const Expanded(
                      child: Text('Total paid',
                          style: TextStyle(fontWeight: FontWeight.w700))),
                  Text('${order['amount']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppColors.deepBlue)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          if (digital)
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, '/digital-library');
              },
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Open library'),
            ),
        ],
      ),
    );
  }

  void _showTracking(BuildContext context, Map<String, dynamic> order) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.local_shipping_rounded, color: AppColors.indigo),
            SizedBox(width: 10),
            Text('Track shipment'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ${order['id']} · status: ${order['status']}.',
                style: const TextStyle(height: 1.6)),
            const SizedBox(height: 10),
            const Text(
              'Physical orders move Paid → Shipped → Delivered. The tracking number is emailed once the parcel is dispatched (simulated in this prototype).',
              style: TextStyle(
                  fontSize: 13.5, height: 1.6, color: AppColors.muted),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

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
                        Text(
                            '${state.orders.length} order(s) · tap a row for details',
                            style:
                                const TextStyle(color: AppColors.muted)),
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
                            InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () => _showDetail(context, o),
                              child: Container(
                                margin:
                                    const EdgeInsets.only(bottom: 14),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.bg,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: AppColors.border),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('${o['id']}',
                                            style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.w800)),
                                        const Spacer(),
                                        StatusChip(
                                            status: '${o['status']}'),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text('${o['items']}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 13.5)),
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
                                                fontWeight:
                                                    FontWeight.w800)),
                                      ],
                                    ),
                                  ],
                                ),
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
                            DataRow(
                                onSelectChanged: (_) =>
                                    _showDetail(context, o),
                                cells: [
                                  DataCell(Text('${o['id']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700))),
                                  DataCell(Text('${o['date']}')),
                                  DataCell(SizedBox(
                                      width: 340,
                                      child: Text('${o['items']}',
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis))),
                                  DataCell(Text('${o['amount']}')),
                                  DataCell(StatusChip(
                                      status: '${o['status']}')),
                                  DataCell(
                                    _hasDigital(o)
                                        ? TextButton(
                                            onPressed: () =>
                                                Navigator.pushNamed(context,
                                                    '/digital-library'),
                                            child:
                                                const Text('Library'),
                                          )
                                        : TextButton(
                                            onPressed: () =>
                                                _showTracking(context, o),
                                            child: const Text('Track'),
                                          ),
                                  ),
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
                        'Physical orders move Paid → Shipped → Delivered with emailed tracking. Digital orders unlock in your library as soon as payment succeeds.',
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
        'Available' => AppColors.teal,
        'Pending' => AppColors.warning,
        _ => AppColors.muted,
      };

  @override
  Widget build(BuildContext context) => Tag(label: status, color: _color);
}
