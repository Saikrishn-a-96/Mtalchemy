import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cards.dart';
import '../../widgets/common.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _asEmployer = false;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return Column(
      children: [
        _Hero(asEmployer: _asEmployer, onToggle: (v) => setState(() => _asEmployer = v)),
        _AboutSection(),
        _WhatWeDo(),
        _Upskilling(courses: Content.courses.sublist(0, 4)),
        _CorporateBand(),
        _StorePreview(),
        _ImpactSection(),
        _Testimonials(),
        _FinalCta(onSignedIn: state.isSignedIn),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// Hero
/// ---------------------------------------------------------------------------
class _Hero extends StatelessWidget {
  final bool asEmployer;
  final ValueChanged<bool> onToggle;
  const _Hero({required this.asEmployer, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 980;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0C2340), Color(0xFF16375C), Color(0xFF2A2F63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: PageWidth(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Reveal(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                                color: AppColors.softYellow, width: 1),
                          ),
                          child: const Text(
                            'PEOPLE DEVELOPMENT CONSULTANCY',
                            style: TextStyle(
                              color: AppColors.softYellow,
                              fontWeight: FontWeight.w800,
                              fontSize: 11.5,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Reveal(
                        delayMs: 90,
                        child: Text(
                          Brand.headline,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: Colors.white, fontSize: 46),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Reveal(
                        delayMs: 160,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Text(
                            'Emotional intelligence, leadership development, team engagement and workplace well-being — delivered through experiential learning, coaching and digital programmes.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .8),
                              fontSize: 16.5,
                              height: 1.7,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Reveal(
                        delayMs: 230,
                        child: Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: [
                            PrimaryButton(
                              label: 'Work With Us',
                              onDark: true,
                              icon: Icons.handshake_rounded,
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/services'),
                            ),
                            GhostButton(
                              label: 'Upskill With Us',
                              light: true,
                              icon: Icons.school_rounded,
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/upskilling'),
                            ),
                            GhostButton(
                              label: 'Shop',
                              light: true,
                              icon: Icons.shopping_bag_rounded,
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/store'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 34),
                      Reveal(
                        delayMs: 300,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'I’m browsing as an:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 10),
                              _RolePill(
                                label: 'Individual',
                                selected: !asEmployer,
                                onTap: () => onToggle(false),
                              ),
                              const SizedBox(width: 8),
                              _RolePill(
                                label: 'Employer',
                                selected: asEmployer,
                                onTap: () => onToggle(true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!narrow) ...[
                  const SizedBox(width: 40),
                  Expanded(child: _HeroCollage(asEmployer: asEmployer)),
                ],
              ],
            ),
            const SizedBox(height: 54),
            Reveal(
              delayMs: 360,
              child: _StatsRow(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RolePill(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: 220.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.softYellow : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13.5,
            color: selected ? AppColors.deepBlue : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _HeroCollage extends StatelessWidget {
  final bool asEmployer;
  const _HeroCollage({required this.asEmployer});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 10,
            child: NetworkImg(
              url: asEmployer ? Media.planning : Media.heroTeam,
              width: 340,
              height: 250,
              radius: BorderRadius.circular(22),
            ).animate().fadeIn(duration: 700.ms).scale(
                begin: const Offset(.96, .96),
                end: const Offset(1, 1),
                duration: 700.ms,
                curve: Curves.easeOutCubic),
          ),
          Positioned(
            left: 0,
            top: 130,
            child: NetworkImg(
              url: asEmployer ? Media.analytics : Media.workshop,
              width: 230,
              height: 170,
              radius: BorderRadius.circular(20),
            ).animate(delay: 220.ms).fadeIn(duration: 700.ms),
          ),
          Positioned(
            right: 40,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .25),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.star_rounded,
                          color: AppColors.softYellow, size: 18),
                      Icon(Icons.star_rounded,
                          color: AppColors.softYellow, size: 18),
                      Icon(Icons.star_rounded,
                          color: AppColors.softYellow, size: 18),
                      Icon(Icons.star_rounded,
                          color: AppColors.softYellow, size: 18),
                      Icon(Icons.star_rounded,
                          color: AppColors.softYellow, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '“We shift mindsets,\nbehaviours, and\nteam culture.”',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      height: 1.4,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ).animate(delay: 380.ms).fadeIn(duration: 600.ms).slideY(
                begin: .1, end: 0, duration: 600.ms, curve: Curves.easeOutCubic),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 26),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .14)),
      ),
      child: ResponsiveBuilder(
        builder: (context, type) {
          final tiles = [
            for (final s in Brand.impactStats)
              Expanded(
                child: Column(
                  children: [
                    Text(
                      s['value']!,
                      style: const TextStyle(
                        color: AppColors.softYellow,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s['label']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .76),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ];
          if (type == ScreenType.mobile) {
            return Column(
              children: [
                Row(children: tiles.sublist(0, 2)),
                const SizedBox(height: 22),
                Row(children: tiles.sublist(2, 4)),
              ],
            );
          }
          return Row(
            children: [
              for (var i = 0; i < tiles.length; i++) ...[
                if (i > 0)
                  Container(
                      height: 46,
                    width: 1,
                    color: Colors.white.withValues(alpha: .16),
                  ),
                tiles[i],
              ],
            ],
          );
        },
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// About strip
/// ---------------------------------------------------------------------------
class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 76),
      child: ResponsiveBuilder(
        builder: (context, type) {
          final image = Stack(
            children: [
              NetworkImg(
                url: Media.aboutTeam,
                width: double.infinity,
                height: 380,
                radius: BorderRadius.circular(24),
              ),
              Positioned(
                left: -6,
                bottom: -6,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.softYellow,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('1,100+',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepBlue)),
                      Text('participants impacted',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepBlue)),
                    ],
                  ),
                ),
              ),
            ],
          );

          final text = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                eyebrow: 'About MT Alchemy',
                title: 'Built from the inside out',
                subtitle:
                    'MT Alchemy is a people development consultancy that helps individuals, teams and organizations thrive by strengthening emotional intelligence, leadership capability, team effectiveness and workplace well-being.',
              ),
              const SizedBox(height: 26),
              _Bullet(icon: Icons.visibility_rounded, label: 'Vision',
                  text: 'Authentic leaders with emotional strength who navigate relationships with clarity and confidence.'),
              const SizedBox(height: 16),
              _Bullet(icon: Icons.flag_rounded, label: 'Mission',
                  text: 'Build emotional intelligence and resilient cultures through experiential learning and meaningful reflection.'),
              const SizedBox(height: 16),
              _Bullet(icon: Icons.auto_awesome_rounded, label: 'Approach',
                  text: 'Experiential learning, practical tools and reflection — not lecture decks that are forgotten by Monday.'),
              const SizedBox(height: 30),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  PrimaryButton(
                    label: 'About us',
                    onPressed: () => Navigator.pushNamed(context, '/about'),
                  ),
                  GhostButton(
                    label: 'Read our impact',
                    onPressed: () => Navigator.pushNamed(context, '/about'),
                  ),
                ],
              ),
            ],
          );

          if (type == ScreenType.mobile) {
            return Column(children: [text, const SizedBox(height: 36), image]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: text),
              const SizedBox(width: 48),
              Expanded(flex: 5, child: image),
            ],
          );
        },
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;
  const _Bullet(
      {required this.icon, required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.purpleSoft,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppColors.purple, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.5,
                      color: AppColors.ink)),
              const SizedBox(height: 4),
              Text(text, style: const TextStyle(height: 1.55, fontSize: 14.5)),
            ],
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// What we do
/// ---------------------------------------------------------------------------
class _WhatWeDo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 76),
      child: Column(
        children: [
          const SectionHeader(
            eyebrow: 'What we do',
            title: 'Six ways we develop people',
            subtitle:
                'From emotional intelligence to ESG, every programme is designed around your people and your organisational reality.',
            align: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 44),
          ResponsiveBuilder(
            builder: (context, type) {
              final count = type == ScreenType.desktop
                  ? 3
                  : type == ScreenType.tablet
                      ? 2
                      : 1;
              final rows = <Widget>[];
              for (var i = 0; i < Content.services.length; i += count) {
                final items = Content.services
                    .sublist(
                        i,
                        (i + count) > Content.services.length
                            ? Content.services.length
                            : i + count)
                    .map((s) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: _ServiceTile(service: s),
                          ),
                        ));
                rows.add(Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: items.toList()));
              }
              return Column(children: rows);
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatefulWidget {
  final ServiceItem service;
  const _ServiceTile({required this.service});

  @override
  State<_ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<_ServiceTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.pushNamed(context, '/services'),
        child: AnimatedContainer(
          duration: 240.ms,
          transform: Matrix4.identity()..translateByDouble(0.0, _hover ? -5.0 : 0.0, 0.0, 1.0),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hover ? s.accent : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: s.accent.withValues(alpha: _hover ? .16 : .05),
                blurRadius: _hover ? 26 : 14,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: s.accent.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(s.icon, color: s.accent, size: 26),
              ),
              const SizedBox(height: 18),
              Text(s.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      height: 1.35,
                      color: AppColors.ink)),
              const SizedBox(height: 10),
              Text(s.summary,
                  style:
                      const TextStyle(fontSize: 14, height: 1.6)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Learn more',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: s.accent)),
                  const SizedBox(width: 6),
                  AnimatedContainer(
                    duration: 220.ms,
                    width: _hover ? 18 : 8,
                    child: Icon(Icons.arrow_forward_rounded,
                        size: 15, color: s.accent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Upskilling preview
/// ---------------------------------------------------------------------------
class _Upskilling extends StatelessWidget {
  final List<Course> courses;
  const _Upskilling({required this.courses});

  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 76),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: SectionHeader(
                  eyebrow: 'Upskilling',
                  title: 'Learn at your own pace',
                  subtitle:
                      'Short, practical courses in emotional intelligence, leadership and well-being — with certificates on completion.',
                ),
              ),
              if (!isMobile(context))
                GhostButton(
                  label: 'Browse all courses',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () =>
                      Navigator.pushNamed(context, '/upskilling'),
                ),
            ],
          ),
          const SizedBox(height: 40),
          ResponsiveBuilder(
            builder: (context, type) {
              final w = MediaQuery.sizeOf(context).width;
              final cross = w < 700
                  ? 1
                  : w < 1080
                      ? 2
                      : 4;
              return GridView.count(
                crossAxisCount: cross,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.76,
                children: [
                  for (final c in courses) CourseCard(course: c),
                ],
              );
            },
          ),
          if (isMobile(context)) ...[
            const SizedBox(height: 22),
            PrimaryButton(
              label: 'Browse all courses',
              wide: true,
              onPressed: () => Navigator.pushNamed(context, '/upskilling'),
            ),
          ],
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Corporate band
/// ---------------------------------------------------------------------------
class _CorporateBand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.deepBlue,
      child: PageWidth(
        padding: const EdgeInsets.symmetric(vertical: 76, horizontal: 24),
        child: ResponsiveBuilder(
          builder: (context, type) {
            final left = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  eyebrow: 'Corporate solutions',
                  title: 'Develop your people.\nStrengthen your organization.',
                  light: true,
                  subtitle:
                    'Most workplace challenges are emotional and interpersonal, not technical. We work on the human system behind performance.',
                ),
                const SizedBox(height: 30),
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
                          border: Border.all(
                              color: Colors.white.withValues(alpha: .16)),
                        ),
                        child: Text(
                          c,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    PrimaryButton(
                      label: 'Talk to MT Alchemy',
                    onDark: true,
                      icon: Icons.forum_rounded,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/contact'),
                    ),
                    GhostButton(
                      label: 'For Organizations',
                    light: true,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/services'),
                    ),
                  ],
                ),
              ],
            );

            final right = Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .06),
                borderRadius: BorderRadius.circular(22),
                border:
                    Border.all(color: Colors.white.withValues(alpha: .14)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('What organisations gain',
                      style: TextStyle(
                          color: AppColors.softYellow,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 18),
                  for (var i = 0; i < Brand.orgOutcomes.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.softYellow, size: 19),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              Brand.orgOutcomes[i],
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .9),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 6),
                  Divider(color: Colors.white.withValues(alpha: .2)),
                  const SizedBox(height: 16),
                  Text(
                    'Customized programmes adapt to diverse workforce and team demographics.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .7),
                      fontSize: 13.5,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            );

            if (type == ScreenType.mobile) {
              return Column(children: [
                left,
                const SizedBox(height: 34),
                right,
              ]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: left),
                const SizedBox(width: 44),
                Expanded(flex: 5, child: right),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Store preview
/// ---------------------------------------------------------------------------
class _StorePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 76),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: SectionHeader(
                  eyebrow: 'Store',
                  title: 'Workbooks, kits & journals',
                  subtitle:
                      'Digital downloads and physical learning materials designed to turn insight into practice.',
                ),
              ),
              if (!isMobile(context))
                GhostButton(
                  label: 'Visit the store',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => Navigator.pushNamed(context, '/store'),
                ),
            ],
          ),
          const SizedBox(height: 40),
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
                  for (final p in Content.products.sublist(0, 4))
                    ProductCard(product: p),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Impact
/// ---------------------------------------------------------------------------
class _ImpactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 76),
      child: Column(
        children: [
          const SectionHeader(
            eyebrow: 'Our impact',
            title: '1,100+ participants and counting',
            subtitle:
                'Across educational institutions, corporate teams, youth leadership programmes, NGOs and community groups.',
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
                childAspectRatio: 0.78,
                children: [
                  for (final s in Content.stories.sublist(0, cross == 1 ? 3 : cross * 2 > 6 ? 6 : cross * 2))
                    StoryCard(story: s),
                ],
              );
            },
          ),
          const SizedBox(height: 34),
          GhostButton(
            label: 'See all impact stories',
            icon: Icons.arrow_forward_rounded,
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Testimonials
/// ---------------------------------------------------------------------------
class _Testimonials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 76),
      child: Column(
        children: [
          const SectionHeader(
            eyebrow: 'Testimonials',
            title: 'What participants say',
            align: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 40),
          ResponsiveBuilder(
            builder: (context, type) {
              final cross = type == ScreenType.mobile ? 1 : 3;
              return GridView.count(
                crossAxisCount: cross,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: cross == 1 ? 1.15 : 0.95,
                children: [
                  for (final t in Content.testimonials)
                    QuoteCard(data: t),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Final CTA
/// ---------------------------------------------------------------------------
class _FinalCta extends StatelessWidget {
  final bool onSignedIn;
  const _FinalCta({required this.onSignedIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.purple, Color(0xFF3E2E6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: PageWidth(
        padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 24),
        child: Column(
          children: [
            const Reveal(
              child: Text(
                'Let’s build a thriving workplace together.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tell us about your team and we will shape a programme around it.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: .82),
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              alignment: WrapAlignment.center,
              children: [
                PrimaryButton(
                  label: 'Submit an enquiry',
                onDark: true,
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => Navigator.pushNamed(context, '/contact'),
                ),
                GhostButton(
                  label: onSignedIn ? 'Go to dashboard' : 'Create an account',
                light: true,
                  onPressed: () => Navigator.pushNamed(
                      context, onSignedIn ? '/dashboard' : '/register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
