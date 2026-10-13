import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    if (state.cart.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 70),
        child: EmptyState(
          icon: Icons.shopping_bag_outlined,
          title: 'Your cart is empty',
          message:
              'Browse the store for workbooks, journals and learning kits — digital items unlock instantly.',
          action: PrimaryButton(
            label: 'Go to store',
            icon: Icons.storefront_rounded,
            onPressed: () => Navigator.pushNamed(context, '/store'),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: ResponsiveBuilder(
            builder: (context, type) {
              final lines = Panel(
                title: 'Shopping cart',
                trailing: Text(
                  '${state.cartCount} item(s)',
                  style: const TextStyle(
                      color: AppColors.muted, fontWeight: FontWeight.w600),
                ),
                child: Column(
                  children: [
                    for (final line in [...state.cart])
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ResponsiveBuilder(
                          builder: (context, ts) {
                            final thumb = NetworkImg(
                              url: line.product.image,
                              width: 92,
                              height: 92,
                              radius: BorderRadius.circular(14),
                            );
                            final details = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(line.product.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16)),
                                    ),
                                    IconButton(
                                      tooltip: 'Remove',
                                      onPressed: () => state
                                          .setQty(line.product, 0),
                                      icon: const Icon(Icons.close_rounded,
                                          size: 19, color: AppColors.muted),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Tag(
                                  label: line.product.isDigital
                                      ? 'DIGITAL'
                                      : 'PHYSICAL',
                                  color: line.product.isDigital
                                      ? AppColors.purple
                                      : AppColors.teal,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _Stepper(
                                      onMinus: () => state.setQty(
                                          line.product, line.qty - 1),
                                      onPlus: () => state.setQty(
                                          line.product, line.qty + 1),
                                      qty: line.qty,
                                    ),
                                    const SizedBox(width: 18),
                                    Text('RM${line.product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                            color: AppColors.deepBlue)),
                                    const Spacer(),
                                    Text(
                                      'RM${(line.product.price * line.qty).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                              ],
                            );

                            if (ts == ScreenType.mobile) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  thumb,
                                  const SizedBox(height: 14),
                                  details,
                                ],
                              );
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                thumb,
                                const SizedBox(width: 16),
                                Expanded(child: details),
                              ],
                            );
                          },
                        ),
                      ).animate().fadeIn(duration: 320.ms),
                  ],
                ),
              );

              final summary = Panel(
                title: 'Order summary',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Row(label: 'Subtotal', value: 'RM${state.subtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 12),
                    const _Row(label: 'Discount', value: '− RM0.00'),
                    const SizedBox(height: 12),
                    _Row(
                      label: 'Shipping',
                      value: state.shipping == 0
                          ? 'Free (digital)'
                          : 'RM${state.shipping.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 17)),
                        ),
                        Text('RM${state.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                                color: AppColors.deepBlue)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Proceed to Checkout',
                      icon: Icons.arrow_forward_rounded,
                      wide: true,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/checkout'),
                    ),
                    const SizedBox(height: 12),
                    GhostButton(
                      label: 'Continue shopping',
                      onPressed: () => Navigator.pushNamed(context, '/store'),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.purpleSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.lock_outline_rounded,
                              size: 17, color: AppColors.purple),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Secure checkout. Digital items unlock immediately after payment.',
                              style: TextStyle(fontSize: 12.5, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

              if (type != ScreenType.desktop) {
                return Column(children: [lines, const SizedBox(height: 20), summary]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: lines),
                  const SizedBox(width: 22),
                  SizedBox(width: 360, child: summary),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final int qty;
  const _Stepper(
      {required this.onMinus, required this.onPlus, required this.qty});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: onMinus,
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Icon(Icons.remove_rounded, size: 18),
              ),
            ),
            SizedBox(
              width: 34,
              child: Text('$qty',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 15)),
            ),
            InkWell(
              onTap: onPlus,
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Icon(Icons.add_rounded, size: 18),
              ),
            ),
          ],
        ),
      );
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 14.5))),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14.5)),
        ],
      );
}
