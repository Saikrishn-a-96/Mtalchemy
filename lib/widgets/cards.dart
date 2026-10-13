import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// Course card used on Learning Hub, Home and dashboards.
class CourseCard extends StatefulWidget {
  final Course course;
  final bool compact;
  const CourseCard({super.key, required this.course, this.compact = false});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.course;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.pushNamed(context, '/course', arguments: c),
        child: AnimatedContainer(
          duration: 240.ms,
          transform: Matrix4.identity()..translateByDouble(0.0, _hover ? -5.0 : 0.0, 0.0, 1.0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hover ? AppColors.purple : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepBlue
                    .withValues(alpha: _hover ? .14 : .05),
                blurRadius: _hover ? 26 : 14,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  NetworkImg(
                    url: c.image,
                    width: double.infinity,
                    height: widget.compact ? 132 : 158,
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Tag(label: c.category, color: AppColors.purple),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.ink,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded,
                            size: 15, color: AppColors.muted),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            c.instructor,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12.5, color: AppColors.muted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Tag(
                            label: c.level,
                            color: AppColors.indigo),
                        const SizedBox(width: 8),
                        Text(
                          '${c.modules} modules · ${c.duration}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        RatingStar(rating: c.rating),
                        const Spacer(),
                        Text(
                          c.price == 0
                              ? 'Free'
                              : 'RM${c.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.deepBlue,
                          ),
                        ),
                      ],
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

/// Product card for the Store and Home previews.
class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.pushNamed(context, '/product', arguments: p),
        child: AnimatedContainer(
          duration: 240.ms,
          transform: Matrix4.identity()..translateByDouble(0.0, _hover ? -5.0 : 0.0, 0.0, 1.0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hover ? AppColors.softYellow : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepBlue
                    .withValues(alpha: _hover ? .14 : .05),
                blurRadius: _hover ? 26 : 14,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  NetworkImg(
                    url: p.image,
                    width: double.infinity,
                    height: 150,
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Tag(
                      label: p.isDigital ? 'DIGITAL' : 'PHYSICAL',
                      color: p.isDigital ? AppColors.purple : AppColors.teal,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.5,
                        color: AppColors.ink,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p.category,
                      style: const TextStyle(
                          fontSize: 12.5, color: AppColors.muted),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        MoneyText(p.price, size: 17),
                        const Spacer(),
                        Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 20,
                          color: _hover ? AppColors.deepBlue : AppColors.muted,
                        ),
                      ],
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

/// Impact story card with participant badge.
class StoryCard extends StatelessWidget {
  final ImpactStory story;
  const StoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              NetworkImg(url: story.image, width: double.infinity, height: 168),
              Positioned(
                left: 12,
                top: 12,
                child: Tag(label: story.clientType, color: AppColors.indigo),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.softYellow,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${story.participants} participants',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.deepBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(story.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16.5,
                        color: AppColors.ink)),
                const SizedBox(height: 8),
                Text('Objective — ${story.objective}',
                    style: const TextStyle(
                        fontSize: 13.5, color: AppColors.muted, height: 1.55)),
                const SizedBox(height: 8),
                Text('Outcome — ${story.outcome}',
                    style: const TextStyle(
                        fontSize: 13.5,
                        color: AppColors.deepBlue,
                        height: 1.55,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    for (final t in story.tags.sublist(
                        0, story.tags.length > 3 ? 3 : story.tags.length))
                      Tag(label: t, color: AppColors.purple),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Testimonial quote card.
class QuoteCard extends StatelessWidget {
  final Map<String, String> data;
  const QuoteCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote_rounded,
              size: 34, color: AppColors.softYellow),
          const SizedBox(height: 12),
          Text(
            data['quote']!,
            style: const TextStyle(
              fontSize: 15.5,
              height: 1.6,
              color: AppColors.ink,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              NetworkImg(
                url: data['avatar']!,
                width: 44,
                height: 44,
                radius: BorderRadius.circular(999),
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['name']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(data['org']!,
                        style: const TextStyle(
                            fontSize: 12.5, color: AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
