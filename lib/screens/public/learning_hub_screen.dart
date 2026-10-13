import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cards.dart';
import '../../widgets/common.dart';

class LearningHubScreen extends StatefulWidget {
  const LearningHubScreen({super.key});

  @override
  State<LearningHubScreen> createState() => _LearningHubScreenState();
}

class _LearningHubScreenState extends State<LearningHubScreen> {
  String _category = 'All';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Course> get _filtered {
    final q = _controller.text.trim().toLowerCase();
    return Content.courses.where((c) {
      final okCat = _category == 'All' || c.category == _category;
      final okQ = q.isEmpty ||
          c.title.toLowerCase().contains(q) ||
          c.category.toLowerCase().contains(q) ||
          c.instructor.toLowerCase().contains(q);
      return okCat && okQ;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Banner(controller: _controller, onChanged: (_) => setState(() {})),
        Band(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 54),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                eyebrow: 'Learning hub',
                title: 'Browse by category',
                subtitle:
                    'Choose a category or search by keyword. Each course shows modules, level, rating and price before you enrol.',
              ),
              const SizedBox(height: 26),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final c in ['All', ...Brand.learningCategories])
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
                          onSelected: (_) =>
                              setState(() => _category = c),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Text('${_filtered.length} courses',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.muted)),
                  const Spacer(),
                  const Icon(Icons.sort_rounded,
                      size: 18, color: AppColors.muted),
                  const SizedBox(width: 6),
                  const Text('Most popular',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13.5)),
                ],
              ),
              const SizedBox(height: 20),
              if (_filtered.isEmpty)
                const EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No courses found',
                  message:
                      'Try a different keyword or reset the category filter to see all learning programmes.',
                )
              else
                ResponsiveBuilder(
                  builder: (context, type) {
                    final w = MediaQuery.sizeOf(context).width;
                    final cross =
                        w < 700 ? 1 : w < 1080 ? 2 : 3;
                    return GridView.count(
                      crossAxisCount: cross,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.76,
                      children: [
                        for (final c in _filtered) CourseCard(course: c),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
        const _LearnerPath(),
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _Banner({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF16375C), Color(0xFF3E2E6B)],
        ),
      ),
      child: PageWidth(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        child: ResponsiveBuilder(
          builder: (context, type) {
            final text = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('UPSKILLING',
                    style: TextStyle(
                        color: AppColors.softYellow,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        fontSize: 12)),
                const SizedBox(height: 14),
                Text(
                  'Learn. Apply. Grow.',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.white, fontSize: 46),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
                  child: Text(
                    'Self-paced courses in emotional intelligence, leadership, communication and well-being — with certificates when you finish.',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: .84),
                        fontSize: 16,
                        height: 1.65),
                  ),
                ),
              ],
            );

            final search = Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Find a course',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    onChanged: onChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search e.g. leadership, mindfulness',
                      prefixIcon: Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in const [
                        'Emotional Intelligence',
                        'Leadership',
                        'Mindfulness'
                      ])
                        ActionChip(
                          label: Text(s),
                          onPressed: () {
                            controller.text = s;
                            onChanged(s);
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: .05, end: 0);

            if (type == ScreenType.mobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [text, const SizedBox(height: 26), search],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: text),
                const SizedBox(width: 40),
                Expanded(flex: 5, child: search),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LearnerPath extends StatelessWidget {
  const _LearnerPath();

  static const steps = [
    ('Register', 'Create your learner profile in under a minute.'),
    ('Browse & enrol', 'Pick a course and pay securely.'),
    ('Learn', 'Watch, read and download modular lessons.'),
    ('Quiz & certificate', 'Pass the assessment and get certified.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 62),
      child: Column(
        children: [
          const SectionHeader(
            eyebrow: 'Learner journey',
            title: 'From visitor to certified learner',
            align: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 40),
          ResponsiveBuilder(
            builder: (context, type) {
              Widget card(int i) {
                final s = steps[i];
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
                      Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.purple,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('${i + 1}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(s.$1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15.5)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(s.$2,
                          style: const TextStyle(
                              fontSize: 13.5, height: 1.55)),
                    ],
                  ),
                );
              }

              if (type == ScreenType.mobile) {
                return Column(
                  children: [
                    for (var i = 0; i < steps.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child:
                            SizedBox(width: double.infinity, child: card(i)),
                      ),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < steps.length; i++) ...[
                    if (i > 0) const SizedBox(width: 14),
                    Expanded(child: card(i)),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 34),
          PrimaryButton(
            label: 'Start learning',
            icon: Icons.arrow_forward_rounded,
            onPressed: () => Navigator.pushNamed(context, '/register'),
          ),
        ],
      ),
    );
  }
}
