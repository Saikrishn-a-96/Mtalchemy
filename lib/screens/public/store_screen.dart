import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cards.dart';
import '../../widgets/common.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  /// 0 = all, 1 = digital, 2 = physical
  int _type = 0;
  String _category = 'All';

  List<Product> get _filtered => Content.products.where((p) {
        final okType = _type == 0 ||
            (_type == 1 && p.isDigital) ||
            (_type == 2 && !p.isDigital);
        final okCat = _category == 'All' || p.category == _category;
        return okType && okCat;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final categories = <String>{
      'All',
      for (final p in Content.products) p.category,
    }.toList();

    return Column(
      children: [
        _StoreBanner(
          type: _type,
          onType: (v) => setState(() => _type = v),
          cartCount: state.cartCount,
        ),
        Band(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 54),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: SectionHeader(
                      eyebrow: 'Store',
                      title: 'Digital & physical products',
                      subtitle:
                          'Workbooks, journals, card decks and learning kits. Digital purchases unlock instantly in My Digital Products.',
                    ),
                  ),
                  if (!isMobile(context))
                    PrimaryButton(
                      label: 'Cart (${state.cartCount})',
                      icon: Icons.shopping_bag_rounded,
                      compact: true,
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
                    ),
                ],
              ),
              const SizedBox(height: 26),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final c in categories)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: _category == c,
                          selectedColor: AppColors.deepBlue,
                          labelStyle: TextStyle(
                            color:
                                _category == c ? Colors.white : AppColors.ink,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (_) => setState(() => _category = c),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              ResponsiveBuilder(
                builder: (context, type) {
                  final w = MediaQuery.sizeOf(context).width;
                  final cross = w < 700 ? 1 : w < 1080 ? 2 : 4;
                  final items = _filtered;
                  if (items.isEmpty) {
                    return const EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'No products here yet',
                      message:
                          'Switch the product type or category to browse other MT Alchemy materials.',
                    );
                  }
                  return GridView.count(
                    crossAxisCount: cross,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.74,
                    children: [for (final p in items) ProductCard(product: p)],
                  );
                },
              ),
            ],
          ),
        ),
        const _StorePromise(),
      ],
    );
  }
}

class _StoreBanner extends StatelessWidget {
  final int type;
  final ValueChanged<int> onType;
  final int cartCount;
  const _StoreBanner(
      {required this.type, required this.onType, required this.cartCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.deepBlue,
      child: PageWidth(
        padding: const EdgeInsets.symmetric(vertical: 54, horizontal: 24),
        child: ResponsiveBuilder(
          builder: (context, type2) {
            final left = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('STORE',
                    style: TextStyle(
                        color: AppColors.softYellow,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        fontSize: 12)),
                const SizedBox(height: 14),
                Text(
                  'Tools that turn insight\ninto practice',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.white, fontSize: 40),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final (i, label) in const [
                        (0, 'All products'),
                        (1, 'Digital'),
                        (2, 'Physical')
                      ])
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: InkWell(
                            onTap: () => onType(i),
                            borderRadius: BorderRadius.circular(9),
                            child: AnimatedContainer(
                              duration: 200.ms,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 9),
                              decoration: BoxDecoration(
                                color: type == i
                                    ? AppColors.softYellow
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13.5,
                                  color: type == i
                                      ? AppColors.deepBlue
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );

            final card = Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Instant digital delivery',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 10),
                  const Text(
                    'Buy a workbook or template pack and it appears straight away in My Digital Products — verified against your purchase.',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      PrimaryButton(
                        label: 'View cart ($cartCount)',
                        compact: true,
                        onPressed: () =>
                            Navigator.pushNamed(context, '/cart'),
                      ),
                      const SizedBox(width: 10),
                      GhostButton(
                        label: 'My orders',
                        compact: true,
                        onPressed: () =>
                            Navigator.pushNamed(context, '/orders'),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 160.ms).slideY(begin: .06, end: 0);

            if (type2 == ScreenType.mobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [left, const SizedBox(height: 24), card],
              );
            }
            return Row(
              children: [
                Expanded(flex: 6, child: left),
                const SizedBox(width: 40),
                Expanded(flex: 5, child: card),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StorePromise extends StatelessWidget {
  const _StorePromise();

  static const items = [
    (Icons.bolt_rounded, 'Instant access',
        'Digital files unlock the moment payment succeeds.'),
    (Icons.local_shipping_rounded, 'Tracked shipping',
        'Physical goods ship within 3 working days.'),
    (Icons.lock_outline_rounded, 'Purchase-verified downloads',
        'Only buyers can access their files.'),
    (Icons.support_agent_rounded, 'Human support',
        'Message us on WhatsApp for order help.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 58),
      child: ResponsiveBuilder(
        builder: (context, type) {
          Widget card(int i) {
            final it = items[i];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.purpleSoft,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(it.$1, color: AppColors.purple, size: 22),
                  ),
                  const SizedBox(height: 14),
                  Text(it.$2,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15.5)),
                  const SizedBox(height: 6),
                  Text(it.$3,
                      style: const TextStyle(fontSize: 13.5, height: 1.5)),
                ],
              ),
            );
          }

          if (type == ScreenType.mobile) {
            return Column(
              children: [
                for (var i = 0; i < items.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: SizedBox(width: double.infinity, child: card(i)),
                  ),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                Expanded(child: card(i)),
              ],
            ],
          );
        },
      ),
    );
  }
}
