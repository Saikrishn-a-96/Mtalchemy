import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cards.dart';
import '../../widgets/common.dart';

class CourseDetailScreen extends StatefulWidget {
  final Object? course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  int _openModule = 0;

  @override
  Widget build(BuildContext context) {
    final Course c = widget.course is Course
        ? widget.course as Course
        : Content.courses.first;
    final state = AppState.instance;
    final enrolled = state.isEnrolled(c.id);

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.deepBlue,
          child: PageWidth(
            padding: const EdgeInsets.symmetric(vertical: 46, horizontal: 24),
            child: ResponsiveBuilder(
              builder: (context, type) {
                final info = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Tag(label: c.category, color: AppColors.softYellow),
                        const SizedBox(width: 10),
                        Tag(label: c.level, color: AppColors.purple),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      c.title,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: Colors.white, fontSize: 40),
                    ),
                    const SizedBox(height: 14),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: Text(
                        c.blurb,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: .84),
                            fontSize: 16,
                            height: 1.65),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Wrap(
                      spacing: 22,
                      runSpacing: 12,
                      children: [
                        _Meta(icon: Icons.person_outline_rounded, text: c.instructor),
                        _Meta(icon: Icons.schedule_rounded, text: c.duration),
                        _Meta(
                            icon: Icons.menu_book_rounded,
                            text: '${c.modules} modules'),
                        _Meta(icon: Icons.signal_cellular_alt_rounded, text: c.level),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.softYellow, size: 18),
                            const SizedBox(width: 5),
                            Text('${c.rating}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ],
                );

                final buy = Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      NetworkImg(
                        url: c.image,
                        height: 150,
                        radius: BorderRadius.circular(14),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Text(
                            'RM${c.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: AppColors.deepBlue),
                          ),
                          const Spacer(),
                          const Text('One-time payment',
                              style: TextStyle(
                                  fontSize: 12.5, color: AppColors.muted)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      if (enrolled)
                        PrimaryButton(
                          label: 'Continue course',
                          icon: Icons.play_circle_rounded,
                          onPressed: () {
                            state.openCourse(c.id);
                            Navigator.pushNamed(context, '/player');
                          },
                        )
                      else ...[
                        PrimaryButton(
                          label: 'Enrol now',
                          icon: Icons.shopping_cart_rounded,
                          onPressed: () {
                            state.enrol(c.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Enrolled in ${c.title}')),
                            );
                            Navigator.pushNamed(context, '/player');
                          },
                        ),
                        const SizedBox(height: 10),
                        GhostButton(
                          label: 'Add to cart',
                          compact: true,
                          onPressed: () => Navigator.pushNamed(context, '/cart'),
                        ),
                      ],
                      const SizedBox(height: 16),
                      for (final f in const [
                        'Certificate of completion',
                        'Lifetime access to lessons',
                        'Downloadable workbooks',
                        'Mobile, tablet & desktop',
                      ])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: Row(
                            children: [
                              const Icon(Icons.check_rounded,
                                  size: 17, color: AppColors.success),
                              const SizedBox(width: 9),
                              Text(f, style: const TextStyle(fontSize: 13.5)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ).animate().fadeIn(delay: 180.ms).slideY(begin: .05, end: 0);

                if (type == ScreenType.mobile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [info, const SizedBox(height: 26), buy],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: info),
                    const SizedBox(width: 40),
                    SizedBox(width: 360, child: buy),
                  ],
                );
              },
            ),
          ),
        ),
        Band(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 56),
          child: ResponsiveBuilder(
            builder: (context, type) {
              final main = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    eyebrow: 'What you will learn',
                    title: 'Learning objectives',
                  ),
                  const SizedBox(height: 20),
                  for (final o in c.objectives)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.purpleSoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.check_rounded,
                                size: 16, color: AppColors.purple),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(o,
                                style: const TextStyle(
                                    fontSize: 15, height: 1.55)),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 34),
                  const SectionHeader(
                    eyebrow: 'Curriculum',
                    title: 'Course modules',
                    subtitle:
                        'Modular lessons designed so different content types (video, PDF, quiz) can be added over time.',
                  ),
                  const SizedBox(height: 20),
                  for (var i = 0; i < c.curriculum.length; i++)
                    _ModuleTile(
                      title: c.curriculum[i],
                      open: _openModule == i,
                      index: i,
                      onTap: () =>
                          setState(() => _openModule = _openModule == i ? -1 : i),
                    ),
                  const SizedBox(height: 34),
                  const SectionHeader(
                    eyebrow: 'Requirements',
                    title: 'Who should take this',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Open to individual learners and corporate cohorts. No prior EQ training required — just a willingness to reflect and practise.',
                    style: TextStyle(height: 1.65, fontSize: 15),
                  ),
                ],
              );

              final side = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your instructor',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 15)),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    colors: [
                                      AppColors.deepBlue,
                                      AppColors.purple
                                    ]),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Text('MT',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800)),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.instructor,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15.5)),
                                  const SizedBox(height: 3),
                                  const Text('Founder | EQ Coach | HRDC Trainer',
                                      style: TextStyle(
                                          fontSize: 12.5,
                                          color: AppColors.purple)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Facilitates experiential programmes for corporate, education and community cohorts across Malaysia.',
                          style: TextStyle(fontSize: 13.5, height: 1.55),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.purpleSoft,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Certificate included',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: AppColors.ink)),
                        const SizedBox(height: 8),
                        const Text(
                          'Complete all lessons and pass the assessment to unlock a verifiable certificate.',
                          style: TextStyle(fontSize: 13.5, height: 1.55),
                        ),
                        const SizedBox(height: 14),
                        PrimaryButton(
                          label: 'See sample certificate',
                          compact: true,
                          onPressed: () =>
                              Navigator.pushNamed(context, '/certificate'),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              if (type == ScreenType.mobile) {
                return Column(children: [main, const SizedBox(height: 30), side]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: main),
                  const SizedBox(width: 40),
                  Expanded(flex: 5, child: side),
                ],
              );
            },
          ),
        ),
        Band(
          color: AppColors.bg,
          padding: const EdgeInsets.symmetric(vertical: 56),
          child: Column(
            children: [
              const SectionHeader(
                eyebrow: 'You may also like',
                title: 'Related courses',
                align: CrossAxisAlignment.center,
              ),
              const SizedBox(height: 32),
              ResponsiveBuilder(
                builder: (context, type) {
                  final w = MediaQuery.sizeOf(context).width;
                  final cross = w < 700 ? 1 : w < 1080 ? 2 : 3;
                  return GridView.count(
                    crossAxisCount: cross,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.76,
                    children: [
                      for (final other in Content.courses
                          .where((x) => x.id != c.id)
                          .take(cross))
                        CourseCard(course: other),
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

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Meta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: AppColors.softYellow),
          const SizedBox(width: 7),
          Text(text,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: .9),
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ],
      );
}

class _ModuleTile extends StatelessWidget {
  final String title;
  final bool open;
  final int index;
  final VoidCallback onTap;
  const _ModuleTile(
      {required this.title,
      required this.open,
      required this.index,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: open ? AppColors.purpleSoft : AppColors.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: open ? AppColors.purple.withValues(alpha: .4) : AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.deepBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('${index + 1}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: 220.ms,
                    child: const Icon(Icons.expand_more_rounded,
                        color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: 260.ms,
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: open
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(62, 0, 16, 16),
                    child: Column(
                      children: const [
                        _Lesson(icon: Icons.play_circle_outline_rounded,
                            label: 'Video lesson · 12 min'),
                        _Lesson(icon: Icons.article_outlined,
                            label: 'Reading · PDF workbook'),
                        _Lesson(icon: Icons.quiz_outlined,
                            label: 'Knowledge check · 5 questions'),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _Lesson extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Lesson({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Row(
          children: [
            Icon(icon, size: 17, color: AppColors.purple),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 13.5)),
          ],
        ),
      );
}
