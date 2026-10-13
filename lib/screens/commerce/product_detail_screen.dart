import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cards.dart';
import '../../widgets/common.dart';

class ProductDetailScreen extends StatefulWidget {
  final Object? product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final Product p = widget.product is Product
        ? widget.product as Product
        : Content.products.first;
    final state = AppState.instance;

    return Column(
      children: [
        Band(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: ResponsiveBuilder(
            builder: (context, type) {
              final gallery = Column(
                children: [
                  NetworkImg(
                    url: p.image,
                    width: double.infinity,
                    height: 380,
                    radius: BorderRadius.circular(22),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      for (final img in [
                        p.image,
                        Media.workspace,
                        Media.booksStack,
                        Media.notebook,
                      ])
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: NetworkImg(
                            url: img,
                            width: 76,
                            height: 76,
                            radius: BorderRadius.circular(14),
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ],
              );

              final info = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Tag(
                        label: p.isDigital ? 'DIGITAL' : 'PHYSICAL',
                        color: p.isDigital
                            ? AppColors.purple
                            : AppColors.teal,
                      ),
                      const SizedBox(width: 10),
                      Tag(label: p.category, color: AppColors.indigo),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(p.name,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 36)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const RatingStar(rating: 4.8),
                      const SizedBox(width: 12),
                      Text('126 reviews',
                          style: TextStyle(
                              fontSize: 13.5,
                              color: AppColors.muted.withValues(alpha: 1))),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(p.blurb, style: const TextStyle(height: 1.7, fontSize: 15.5)),
                  const SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('RM${p.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepBlue)),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text(
                          p.isDigital
                              ? 'Instant download'
                              : 'Stock: ${p.stock} units',
                          style: const TextStyle(
                              fontSize: 13.5, color: AppColors.muted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  if (!p.isDigital) ...[
                    const Text('Quantity',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13.5)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _QtyBtn(
                          icon: Icons.remove_rounded,
                          onTap: () =>
                              setState(() => _qty = _qty > 1 ? _qty - 1 : 1),
                        ),
                        AnimatedSwitcher(
                          duration: 200.ms,
                          child: Container(
                            key: ValueKey(_qty),
                            width: 56,
                            alignment: Alignment.center,
                            child: Text('$_qty',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ),
                        _QtyBtn(
                          icon: Icons.add_rounded,
                          onTap: () => setState(() => _qty++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Add to Cart',
                          icon: Icons.shopping_bag_rounded,
                          wide: true,
                          onPressed: () {
                            state.addToCart(p, qty: _qty);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${p.name} added to cart'),
                                action: SnackBarAction(
                                  label: 'View cart',
                                  textColor: AppColors.softYellow,
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/cart'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      GhostButton(
                        label: 'Buy now',
                        onPressed: () {
                          state.addToCart(p, qty: _qty);
                          Navigator.pushNamed(context, '/checkout');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _Line(
                          icon: p.isDigital
                              ? Icons.download_rounded
                              : Icons.local_shipping_rounded,
                          text: p.isDigital
                              ? 'File unlocks in My Digital Products after payment'
                              : 'Ships within 3 working days · tracking provided',
                        ),
                        const SizedBox(height: 10),
                        const _Line(
                            icon: Icons.lock_outline_rounded,
                            text: 'Purchase-verified access — no public links'),
                        const SizedBox(height: 10),
                        const _Line(
                            icon: Icons.support_agent_rounded,
                            text: 'WhatsApp support for order issues'),
                      ],
                    ),
                  ),
                ],
              );

              if (type == ScreenType.mobile) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [gallery, const SizedBox(height: 26), info]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: gallery),
                  const SizedBox(width: 40),
                  Expanded(flex: 6, child: info),
                ],
              );
            },
          ),
        ),
        Band(
          color: AppColors.bg,
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(const [
                          'Description',
                          'What’s included',
                          'Shipping & returns'
                        ][i]),
                        selected: _tab == i,
                        selectedColor: AppColors.deepBlue,
                        labelStyle: TextStyle(
                          color: _tab == i ? Colors.white : AppColors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                        onSelected: (_) => setState(() => _tab = i),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Text(
                  _tab == 0
                      ? '${p.blurb} Designed with MT Alchemy’s human-centred approach — short sections, reflection prompts and practical exercises you can apply the same week.'
                      : _tab == 1
                          ? (p.isDigital
                              ? 'Main workbook (PDF, 62 pages) · Printable reflection sheets · Bonus tracker template · Lifetime access from your library.'
                              : 'Printed workbook · Reflection card deck · Progress tracker · Gift-ready packaging with a facilitator note.')
                          : (p.isDigital
                              ? 'No shipping required. Digital files are delivered instantly after payment and remain available in My Digital Products.'
                              : 'Shipping RM15 flat rate within Malaysia. Free shipping above RM200. Returns accepted within 14 days if unopened.'),
                  style: const TextStyle(height: 1.75, fontSize: 15.5),
                ),
              ),
            ],
          ),
        ),
        Band(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 54),
          child: Column(
            children: [
              const SectionHeader(
                eyebrow: 'You may also like',
                title: 'Related products',
                align: CrossAxisAlignment.center,
              ),
              const SizedBox(height: 30),
              ResponsiveBuilder(
                builder: (context, type) {
                  final w = MediaQuery.sizeOf(context).width;
                  final cross = w < 700 ? 1 : w < 1080 ? 2 : 4;
                  return GridView.count(
                    crossAxisCount: cross,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.74,
                    children: [
                      for (final other
                          in Content.products.where((x) => x.id != p.id).take(cross))
                        ProductCard(product: other),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 20, color: AppColors.deepBlue),
        ),
      );
}

class _Line extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Line({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 18, color: AppColors.purple),
          const SizedBox(width: 12),
          Expanded(
              child:
                  Text(text, style: const TextStyle(fontSize: 13.5, height: 1.5))),
        ],
      );
}
