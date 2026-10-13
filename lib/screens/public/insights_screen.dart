import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  String _category = 'All';
  String _query = '';

  List<Insight> get _filtered {
    final q = _query.trim().toLowerCase();
    return Content.insights.where((i) {
      final okCat = _category == 'All' || i.category == _category;
      final okQ =
          q.isEmpty || i.title.toLowerCase().contains(q);
      return okCat && okQ;
    }).toList();
  }

  void _reset() => setState(() {
        _category = 'All';
        _query = '';
      });

  void _openArticle(Insight insight) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(insight.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: [
                Tag(label: insight.category, color: AppColors.purple),
                Tag(label: insight.readTime, color: AppColors.indigo),
                const Tag(label: 'PREVIEW', color: AppColors.warning),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              'This card previews the MT Alchemy insights library. Full-length articles, videos and guides ship with the content release — subscribe below and we will notify you.',
              style: TextStyle(height: 1.65, fontSize: 14),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = <String>{'All', ...Content.insights.map((i) => i.category)}
        .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.deepBlue,
          child: PageWidth(
            padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('INSIGHTS',
                    style: TextStyle(
                        color: AppColors.softYellow,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        fontSize: 12)),
                const SizedBox(height: 14),
                Text(
                  'Ideas for healthier, smarter workplaces',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.white, fontSize: 42),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    'Articles, videos, guides and resources on emotional intelligence, leadership, mindfulness and organizational development.',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: .84),
                        fontSize: 16,
                        height: 1.65),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search insights',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor:
                        Colors.white.withValues(alpha: .12),
                    hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: .6)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: .25)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.softYellow),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Band(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 54),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 28),
              if (_filtered.isEmpty)
                EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No insights found',
                  message:
                      'Try a different keyword or reset the filters.',
                  action: GhostButton(
                    label: 'Reset filters',
                    compact: true,
                    onPressed: _reset,
                  ),
                )
              else
                ResponsiveBuilder(
                  builder: (context, type) {
                    final perRow = type == ScreenType.mobile
                        ? 1
                        : 2;
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        const gap = 20.0;
                        final w = constraints.maxWidth;
                        final itemW = perRow == 1
                            ? w
                            : (w - gap * (perRow - 1)) / perRow;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final i in _filtered)
                              SizedBox(
                                width: itemW,
                                child: _InsightCard(
                                  insight: i,
                                  onOpen: () => _openArticle(i),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
        const _Subscribe(),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final Insight insight;
  final VoidCallback onOpen;
  const _InsightCard({required this.insight, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final i = insight;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onOpen,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 8,
              child: NetworkImg(url: i.image, width: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Tag(label: i.category, color: AppColors.purple),
                      Tag(label: i.readTime, color: AppColors.indigo),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(i.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          height: 1.35,
                          color: AppColors.ink)),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Text('Read preview',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                              color: AppColors.deepBlue)),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded,
                          size: 15, color: AppColors.deepBlue),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 420.ms);
  }
}

class _Subscribe extends StatefulWidget {
  const _Subscribe();

  @override
  State<_Subscribe> createState() => _SubscribeState();
}

class _SubscribeState extends State<_Subscribe> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.purple,
      child: PageWidth(
        padding: const EdgeInsets.symmetric(vertical: 58, horizontal: 24),
        child: ResponsiveBuilder(
          builder: (context, type) {
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Get insights in your inbox',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(
                  'One thoughtful email a month on EQ, leadership and workplace well-being. No spam, unsubscribe anytime.',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: .85),
                      fontSize: 15,
                      height: 1.6),
                ),
              ],
            );

            final form = Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.ink),
                    decoration: const InputDecoration(
                      hintText: 'you@company.com',
                      labelText: 'Email address',
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
                  PrimaryButton(
                    label: 'Subscribe',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      final email = _email.text.trim();
                      final added = AppState.instance
                          .subscribeNewsletter(email);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(added
                                ? 'Subscribed — thank you!'
                                : 'That email is already subscribed')),
                      );
                      if (added) _email.clear();
                    },
                  ),
                ],
              ),
            );

            if (type == ScreenType.mobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [copy, const SizedBox(height: 22), form],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: copy),
                const SizedBox(width: 40),
                Expanded(flex: 5, child: form),
              ],
            );
          },
        ),
      ),
    );
  }
}
