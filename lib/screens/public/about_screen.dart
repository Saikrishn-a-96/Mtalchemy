import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cards.dart';
import '../../widgets/common.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _PageHero(
          eyebrow: 'About MT Alchemy',
          title: 'Who we are',
          subtitle:
              'A people-development consultancy working with individuals, teams and organizations through a human-centered approach to development.',
          image: Media.aboutTeam,
        ),
        _WhoWeAre(),
        _VisionMission(),
        _Approach(),
        _WhyEq(),
        _Impact(),
        _Founder(),
        _Team(),
        _Cta(),
      ],
    );
  }
}

class _PageHero extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final String image;
  const _PageHero({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetworkImg(url: image),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.deepBlue.withValues(alpha: .94),
                  AppColors.deepBlue.withValues(alpha: .62),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Center(
            child: PageWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    eyebrow.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.softYellow,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: Colors.white, fontSize: 44),
                  ),
                  const SizedBox(height: 14),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .85),
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}

class _WhoWeAre extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveBuilder(
        builder: (context, type) {
          final text = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                eyebrow: 'Who we are',
                title: 'Sustainable success is built from the inside out',
                subtitle:
                    'Founded on the belief that lasting transformation begins with understanding both people and systems, we help organizations cultivate self-awareful individuals, resilient teams and healthy workplace cultures.',
              ),
              const SizedBox(height: 24),
              Text(
                'Through experiential learning, practical tools and meaningful reflection, we translate insight into lasting behavioural change â€” when people grow, teams flourish, and organizations thrive.',
                style: const TextStyle(height: 1.7, fontSize: 15.5),
              ),
            ],
          );
          final quote = Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.purpleSoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.purple.withValues(alpha: .25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote_rounded,
                    color: AppColors.purple, size: 36),
                const SizedBox(height: 14),
                Text(
                  Brand.tagline,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.45,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('MT Alchemy',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.purple)),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: .04, end: 0);

          if (type == ScreenType.mobile) {
            return Column(children: [text, const SizedBox(height: 30), quote]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: text),
              const SizedBox(width: 44),
              Expanded(flex: 5, child: quote),
            ],
          );
        },
      ),
    );
  }
}

class _VisionMission extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveBuilder(
        builder: (context, type) {
          Widget card(String icon, String title, String body, Color c) =>
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: c.withValues(alpha: .14),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        title == 'Vision'
                            ? Icons.visibility_rounded
                            : Icons.flag_rounded,
                        color: c,
                        size: 25,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(title,
                        style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink)),
                    const SizedBox(height: 12),
                    Text(body, style: const TextStyle(height: 1.65, fontSize: 15)),
                  ],
                ),
              );

          final vision = card(
              'v',
              'Vision',
              'To develop authentic leaders with emotional strength who can navigate personal and professional relationships with clarity and confidence in todayâ€™s technology-driven world.',
              AppColors.deepBlue);
          final mission = card(
              'm',
              'Mission',
              'To help individuals and organizations build emotional intelligence and resilient cultures through experiential learning, creating fulfilling and sustainable work environments.',
              AppColors.purple);

          if (type == ScreenType.mobile) {
            return Column(
                children: [vision, const SizedBox(height: 22), mission]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: vision),
              const SizedBox(width: 22),
              Expanded(child: mission),
            ],
          );
        },
      ),
    );
  }
}


class _Approach extends StatelessWidget {
  static const steps = [
    ('1', 'Self-awareness', 'Know your patterns, triggers and strengths.'),
    ('2', 'Emotional intelligence',
        'Regulate and read emotion in yourself and others.'),
    ('3', 'Effective communication', 'Say what matters, listen for meaning.'),
    ('4', 'Authentic leadership', 'Lead with clarity and consistency.'),
    ('5', 'Resilient culture', 'Sustain high performance without burnout.'),
  ];

  Widget _card(BuildContext context, int i) {
    final s = steps[i];
    return Reveal(
      delayMs: i * 90,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.deepBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(s.$1,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 14),
            Text(s.$2,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.ink)),
            const SizedBox(height: 8),
            Text(s.$3, style: const TextStyle(fontSize: 13.5, height: 1.55)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          const SectionHeader(
            eyebrow: 'Our solution',
            title: 'The MT Alchemy approach',
            subtitle:
                'We create lasting behavioural change through consistent experiential learning, practical tools and application.',
            align: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 46),
          ResponsiveBuilder(
            builder: (context, type) {
              if (type == ScreenType.mobile) {
                return Column(
                  children: [
                    for (var i = 0; i < steps.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                            width: double.infinity, child: _card(context, i)),
                      ),
                  ],
                );
              }
              final rows = <Widget>[];
              for (var i = 0; i < steps.length; i += 3) {
                final children = <Widget>[];
                for (var j = i; j < i + 3 && j < steps.length; j++) {
                  children.add(Expanded(child: _card(context, j)));
                  if (j < i + 2 && j + 1 < steps.length) {
                    children.add(const SizedBox(width: 16));
                  }
                }
                rows.add(Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: children),
                ));
              }
              return Column(children: rows);
            },
          ),
        ],
      ),
    );
  }
}

class _WhyEq extends StatelessWidget {
  static const bars = [
    ('Mental well-being issues in Malaysia (2019)', 0.311, '31.1%'),
    ('Mental well-being issues in Malaysia (2015)', 0.107, '10.7%'),
    ('EQ training vs technical training', 0.18, 'Low EQ focus'),
    ('Impact of EQ on career success', 0.92, 'Strong'),
  ];

  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.deepBlue,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveBuilder(
        builder: (context, type) {
          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                eyebrow: 'Why EQ matters',
                title: 'The workplace reality',
                light: true,
                subtitle:
                    'Mental health issues in Malaysia rose from 8.9% to 31.1% (Springer, 2024). While technical skills remain important, many workplace challenges stem from emotional and interpersonal factors.',
              ),
              const SizedBox(height: 26),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final c in Brand.workplaceChallenges)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(c,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                ],
              ),
            ],
          );

          final right = Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .07),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Research snapshot',
                    style: TextStyle(
                        color: AppColors.softYellow,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 1.3)),
                const SizedBox(height: 20),
                for (final b in bars) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(b.$1,
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: .86),
                                fontSize: 13)),
                      ),
                      const SizedBox(width: 12),
                      Text(b.$3,
                          style: const TextStyle(
                              color: AppColors.softYellow,
                              fontWeight: FontWeight.w800,
                              fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: b.$2),
                    duration: 900.ms,
                    curve: Curves.easeOutCubic,
                    builder: (context, v, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: v,
                        minHeight: 8,
                        backgroundColor: Colors.white.withValues(alpha: .15),
                        valueColor: const AlwaysStoppedAnimation(
                            AppColors.softYellow),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
                Text(
                  'Sources: Springer 2024 · BMC 2024 · NIH 2023 · Harvard Business School 2019',
                  style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.white.withValues(alpha: .6),
                      height: 1.5),
                ),
              ],
            ),
          );

          if (type == ScreenType.mobile) {
            return Column(children: [left, const SizedBox(height: 32), right]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: left),
              const SizedBox(width: 40),
              Expanded(flex: 5, child: right),
            ],
          );
        },
      ),
    );
  }
}

class _Impact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          const SectionHeader(
            eyebrow: 'Impact stories & portfolio',
            title: 'Our reach',
            subtitle:
                'Educational institutions, corporate teams, youth leadership programmes, NGOs, community groups and educators.',
          ),
          const SizedBox(height: 40),
          ResponsiveBuilder(
            builder: (context, type) {
              final cross = type == ScreenType.mobile
                  ? 1
                  : type == ScreenType.tablet
                      ? 2
                      : 3;
              return GridView.count(
                crossAxisCount: cross,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.78,
                children: [
                  for (final s in Content.stories) StoryCard(story: s),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Founder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveBuilder(
        builder: (context, type) {
          final photo = Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [AppColors.deepBlue, AppColors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withValues(alpha: .3),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'MT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          );

          final bio = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                eyebrow: 'Our founder',
                title: 'Mabel Tan KH',
                subtitle: 'Founder | EQ Coach | HRDC Certified Trainer',
              ),
              const SizedBox(height: 22),
              const Text(
                'Mabel Tan KH is naturally drawn to understanding both systems and people. She believes that many organizational challenges cannot be solved through processes alone, nor by focusing solely on individuals. Lasting transformation occurs when both are understood and developed together.',
                style: TextStyle(height: 1.7, fontSize: 15.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'Guided by this perspective, she helps individuals, teams and organizations cultivate greater self-awareness, emotional intelligence and resilience — supporting the development of authentic leaders and healthy workplace cultures that can thrive in a fast-changing world.',
                style: TextStyle(height: 1.7, fontSize: 15.5),
              ),
              const SizedBox(height: 24),
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Tag(label: 'EQ Coach'),
                  Tag(label: 'HRDC Certified Trainer'),
                  Tag(label: 'Experiential Learning'),
                ],
              ),
            ],
          );

          if (type == ScreenType.mobile) {
            return Column(children: [photo, const SizedBox(height: 30), bio]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: photo),
              const SizedBox(width: 46),
              Expanded(flex: 7, child: bio),
            ],
          );
        },
      ),
    );
  }
}

class _Team extends StatelessWidget {
  static const members = [
    ('Mabel Tan KH', 'Founder, EQ Coach, HRDC Certified Trainer',
        'Leads vision and content development', Media.portraitW2),
    ('Esther Ng', 'Consultant & Operation Advisor, ISO 9001 Auditor',
        'Leads operations and business development', Media.portraitW1),
    ('Development Team', 'Cross-platform engineering',
        'Builds and maintains the MT Alchemy digital platform', Media.portraitM1),
  ];

  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: Column(
        children: [
          const SectionHeader(
            eyebrow: 'Our team',
            title: 'Guided by experience',
            subtitle:
                'A growing team of trainers, facilitators, consultants and specialists shaping healthy workplace cultures.',
            align: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 40),
          ResponsiveBuilder(
            builder: (context, type) {
              final cross = type == ScreenType.mobile
                  ? 1
                  : type == ScreenType.tablet
                      ? 2
                      : 3;
              return GridView.count(
                crossAxisCount: cross,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.82,
                children: [
                  for (final m in members)
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NetworkImg(
                            url: m.$4,
                            width: 76,
                            height: 76,
                            radius: BorderRadius.circular(20),
                          ),
                          const SizedBox(height: 16),
                          Text(m.$1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                  color: AppColors.ink)),
                          const SizedBox(height: 6),
                          Text(m.$2,
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.purple)),
                          const SizedBox(height: 10),
                          Text(m.$3,
                              style: const TextStyle(fontSize: 13.5, height: 1.55)),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Cta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.purple,
      child: PageWidth(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        child: ResponsiveBuilder(
          builder: (context, type) {
            final text = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Let’s build a thriving workplace together.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.3)),
                const SizedBox(height: 10),
                Text(
                  'WhatsApp ${Brand.phone} · ${Brand.email}',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: .85), fontSize: 15),
                ),
              ],
            );
            final btn = PrimaryButton(
              label: 'Contact us',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => Navigator.pushNamed(context, '/contact'),
            );

            if (type == ScreenType.mobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [text, const SizedBox(height: 20), btn],
              );
            }
            return Row(
              children: [Expanded(child: text), const SizedBox(width: 24), btn],
            );
          },
        ),
      ),
    );
  }
}
