import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  String _category = 'All';

  static const _types = ['Articles', 'Videos', 'Guides', 'Resources'];

  List<Insight> get _filtered => _category == 'All'
      ? Content.insights
      : Content.insights.where((i) => i.category == _category).toList();

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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final t in _types)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 9),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                  color: Colors.white
                                      .withValues(alpha: .22)),
                            ),
                            child: Text(t,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                        ),
                    ],
                  ),
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
              ResponsiveBuilder(
                builder: (context, type) {
                  final w = MediaQuery.sizeOf(context).width;
                  final cross = w < 700 ? 1 : w < 1080 ? 2 : 2;
                  return GridView.count(
                    crossAxisCount: cross,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.35,
                    children: [
                      for (final i in _filtered)
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.bg,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Row(
                            children: [
                              NetworkImg(url: i.image, width: 190),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Tag(
                                              label: i.category,
                                              color: AppColors.purple),
                                          const SizedBox(width: 8),
                                          Text(i.readTime,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.muted)),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(i.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 17,
                                              height: 1.35,
                                              color: AppColors.ink)),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          const Text('Read article',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13.5,
                                                  color: AppColors.deepBlue)),
                                          const SizedBox(width: 6),
                                          const Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 15,
                                              color: AppColors.deepBlue),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 420.ms),
                    ],
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
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Subscribed — thank you!')),
                        );
                        _email.clear();
                      }
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
