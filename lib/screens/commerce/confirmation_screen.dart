import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final total = args is double ? args : AppState.instance.total;
    final state = AppState.instance;
    final order = state.orders.isNotEmpty
        ? state.orders.first
        : <String, dynamic>{
            'id': '#MA1000',
            'date': '12 Oct 2026',
            'amount': 'RM0.00',
            'status': 'Paid',
            'items': '',
          };
    final hasPhysical = state.orders.isNotEmpty &&
        state.orders.first['items'].toString().contains('Team Reflection');

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Container(
            padding: const EdgeInsets.all(34),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: .12),
                  blurRadius: 46,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: .15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded,
                          size: 40, color: AppColors.success),
                    ).animate().scale(
                        begin: const Offset(.6, .6),
                        end: const Offset(1, 1),
                        duration: 520.ms,
                        curve: Curves.elasticOut),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Thank you for your order.',
                              style: TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Text(
                            'Payment successful — a confirmation has been sent to your email.',
                            style: TextStyle(
                                height: 1.55,
                                color: AppColors.muted.withValues(alpha: 1)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                ResponsiveBuilder(
                  builder: (context, type) {
                    final details = Wrap(
                      spacing: 18,
                      runSpacing: 18,
                      children: [
                        _Info(label: 'Order number', value: '${order['id']}'),
                        _Info(label: 'Amount paid', value: 'RM$total'),
                        _Info(
                            label: 'Payment status',
                            value: '${order['status']}'),
                        _Info(label: 'Date', value: '${order['date']}'),
                      ],
                    );
                    if (type == ScreenType.mobile) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            details,
                          ]);
                    }
                    return details;
                  },
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Items',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15)),
                      const SizedBox(height: 10),
                      Text(
                        '${order['items']}',
                        style: const TextStyle(height: 1.6, fontSize: 14.5),
                      ),
                      if (hasPhysical) ...[
                        const SizedBox(height: 14),
                        const Row(
                          children: [
                            Icon(Icons.local_shipping_rounded,
                                size: 18, color: AppColors.indigo),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Shipping information: tracking number will be emailed once the order is dispatched.',
                                style: TextStyle(fontSize: 13.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                ResponsiveBuilder(
                  builder: (context, type) {
                    final actions = Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        PrimaryButton(
                          label: 'Download Product',
                          icon: Icons.download_rounded,
                          onPressed: () =>
                              Navigator.pushNamed(context, '/digital-library'),
                        ),
                        GhostButton(
                          label: 'Track Order',
                          onPressed: () =>
                              Navigator.pushNamed(context, '/orders'),
                        ),
                        GhostButton(
                          label: 'Continue shopping',
                          onPressed: () =>
                              Navigator.pushNamed(context, '/store'),
                        ),
                      ],
                    );
                    if (type == ScreenType.mobile) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PrimaryButton(
                            label: 'Download Product',
                            icon: Icons.download_rounded,
                            wide: true,
                            onPressed: () => Navigator.pushNamed(
                                context, '/digital-library'),
                          ),
                        ],
                      );
                    }
                    return actions;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 460.ms);
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;
  const _Info({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(),
                style: const TextStyle(
                    fontSize: 10.5,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.w800,
                    color: AppColors.muted)),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.ink)),
          ],
        ),
      );
}
