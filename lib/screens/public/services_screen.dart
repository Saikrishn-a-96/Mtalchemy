import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _filter = 0;

  static const _tabs = [
    'All services',
    'EQ & Mindfulness',
    'Leadership',
    'Team',
    'Assessment',
    'CSR & ESG',
    'Customized',
  ];

  bool _matches(ServiceItem s) {
    if (_filter == 0) return true;
    final t = _tabs[_filter].toLowerCase();
    if (t.contains('eq')) return s.title.contains('Emotional');
    if (t.contains('leadership')) return s.title.contains('Leadership');
    if (t.contains('team')) return s.title.contains('Team');
    if (t.contains('assessment')) return s.title.contains('Assessment');
    if (t.contains('csr')) return s.title.contains('CSR');
    return s.title.contains('Customized');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Head(),
        Band(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                eyebrow: 'Services for organizations',
                title: 'Service directory',
                subtitle:
                    'Programmes for HR, people leaders and organizations. Select a service to send an enquiry — or request a free consultation.',
              ),
              const SizedBox(height: 28),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < _tabs.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(_tabs[i]),
                          selected: _filter == i,
                          selectedColor: AppColors.deepBlue,
                          labelStyle: TextStyle(
                            color:
                                _filter == i ? Colors.white : AppColors.ink,
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (_) => setState(() => _filter = i),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              for (final s in Content.services.where(_matches))
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ServiceRow(service: s),
                ),
            ],
          ),
        ),
        const _Programmes(),
        const _Coaching(),
        const _ConsultationCta(),
      ],
    );
  }
}

class _Head extends StatelessWidget {
  const _Head();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.deepBlue, AppColors.indigo],
        ),
      ),
      child: PageWidth(
        padding: const EdgeInsets.symmetric(vertical: 58, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SERVICES',
                style: TextStyle(
                    color: AppColors.softYellow,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    fontSize: 12)),
            const SizedBox(height: 14),
            Text(
              'Programmes that change behaviour,\nnot just attendance',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.white, fontSize: 42),
            ),
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                'Every engagement is designed around your organisation’s reality — audience, constraints and the outcomes you need to see.',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: .84),
                    fontSize: 16,
                    height: 1.65),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Get a Free Consultation',
              icon: Icons.event_available_rounded,
              onPressed: () => Navigator.pushNamed(context, '/contact'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceRow extends StatefulWidget {
  final ServiceItem service;
  const _ServiceRow({required this.service});

  @override
  State<_ServiceRow> createState() => _ServiceRowState();
}

class _ServiceRowState extends State<_ServiceRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.service;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: s.accent.withValues(alpha: .13),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(s.icon, color: s.accent, size: 27),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17.5,
                                color: AppColors.ink)),
                        const SizedBox(height: 6),
                        Text(s.summary,
                            style: const TextStyle(
                                fontSize: 14, height: 1.55)),
                        AnimatedSize(
                          duration: 260.ms,
                          curve: Curves.easeOut,
                          alignment: Alignment.topCenter,
                          child: _open
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('What’s covered — ${s.detail}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              height: 1.6,
                                              color: AppColors.ink)),
                                      const SizedBox(height: 14),
                                      Wrap(
                                        spacing: 10,
                                        children: [
                                          PrimaryButton(
                                            label: 'Enquiry',
                                            compact: true,
                                            onPressed: () =>
                                                Navigator.pushNamed(
                                                    context, '/contact'),
                                          ),
                                          GhostButton(
                                            label: 'Get a Free Consultation',
                                            compact: true,
                                            onPressed: () =>
                                                Navigator.pushNamed(
                                                    context, '/contact'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(width: double.infinity),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: 240.ms,
                    child: const Icon(Icons.expand_more_rounded,
                        color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 420.ms);
  }
}

class _Programmes extends StatelessWidget {
  const _Programmes();

  static const programmes = [
    (
      'Emotional Intelligence Essentials',
      'Public Programme',
      'RM 450 / participant',
      '2 days · In-person or virtual · Max 25 pax',
      'Foundational EQ for individual contributors and new managers.'
    ),
    (
      'Leadership Communication Lab',
      'Public Programme',
      'RM 690 / participant',
      '3 days · In-person · Max 20 pax',
      'Feedback, difficult conversations and executive presence.'
    ),
    (
      'Organization Well-being Sprint',
      'Corporate Programme',
      'Request a Quote',
      '8 weeks · On-site + digital · Any headcount',
      'Assessment, manager enablement and a 90-day action plan.'
    ),
    (
      'Team Effectiveness Offsite',
      'Corporate Programme',
      'Request a Quote',
      '1–2 days · On-site · Custom headcount',
      'Diagnose dysfunction, rebuild trust and set accountability norms.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 68),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Corporate programmes',
            title: 'Browse programmes',
            subtitle:
                'Public programmes have fixed pricing. Corporate programmes are shaped around your team and quoted on request.',
          ),
          const SizedBox(height: 34),
          ResponsiveBuilder(
            builder: (context, type) {
              final cross = type == ScreenType.mobile
                  ? 1
                  : type == ScreenType.tablet
                      ? 2
                      : 2;
              return GridView.count(
                crossAxisCount: cross,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 1.15,
                children: [
                  for (final p in programmes)
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Tag(
                                label: p.$2,
                                color: p.$2 == 'Public Programme'
                                    ? AppColors.teal
                                    : AppColors.purple,
                              ),
                              const Spacer(),
                              Text(p.$4.split(' · ').first,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.muted,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(p.$1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  height: 1.3,
                                  color: AppColors.ink)),
                          const SizedBox(height: 8),
                          Text(p.$5,
                              style: const TextStyle(
                                  fontSize: 14, height: 1.55)),
                          const Spacer(),
                          Text(p.$4,
                              style: const TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.muted,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Text(
                                p.$3,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: AppColors.deepBlue),
                              ),
                              const Spacer(),
                              PrimaryButton(
                                label: p.$2 == 'Public Programme'
                                    ? 'Enrol'
                                    : 'Request Quote',
                                compact: true,
                                onPressed: () => Navigator.pushNamed(
                                    context, '/contact'),
                              ),
                            ],
                          ),
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

class _Coaching extends StatelessWidget {
  const _Coaching();

  static const focus = [
    ('Career guidance', Icons.explore_rounded),
    ('Career transitions', Icons.alt_route_rounded),
    ('Relationships', Icons.favorite_rounded),
    ('Personal development', Icons.trending_up_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 68),
      child: ResponsiveBuilder(
        builder: (context, type) {
          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                eyebrow: 'Individual coaching',
                title: 'One-to-one coaching',
                subtitle:
                    'Confidential sessions for professionals who want clarity, confidence and a plan — not generic advice.',
              ),
              const SizedBox(height: 24),
              const Text('How it works',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 12),
              for (final step in const [
                ('1', 'Discovery call — 20 min, free'),
                ('2', 'Assessment & goal setting'),
                ('3', 'Coaching sessions (60 min each)'),
                ('4', 'Progress review & next steps'),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.softYellow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(step.$1,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.deepBlue)),
                      ),
                      const SizedBox(width: 12),
                      Text(step.$2,
                          style: const TextStyle(fontSize: 14.5)),
                    ],
                  ),
                ),
              const SizedBox(height: 22),
              PrimaryButton(
                label: 'Book a Coaching Session',
                icon: Icons.calendar_month_rounded,
                onPressed: () => Navigator.pushNamed(context, '/contact'),
              ),
            ],
          );

          final right = Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Coaching focus areas',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 18),
                for (final f in focus)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(f.$2, color: AppColors.purple, size: 22),
                        const SizedBox(width: 14),
                        Text(f.$1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14.5)),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            size: 13, color: AppColors.muted),
                      ],
                    ),
                  ),
                const SizedBox(height: 6),
                const Text('FAQs and testimonials available on request.',
                    style: TextStyle(fontSize: 13)),
              ],
            ),
          );

          if (type == ScreenType.mobile) {
            return Column(children: [left, const SizedBox(height: 30), right]);
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

class _ConsultationCta extends StatelessWidget {
  const _ConsultationCta();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.deepBlue,
      child: PageWidth(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        child: ResponsiveBuilder(
          builder: (context, type) {
            final text = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Get a Free Consultation',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text(
                  'Talk to MT Alchemy about your team’s challenges and receive a proposed programme outline within 3 working days.',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: .8),
                      fontSize: 15.5,
                      height: 1.6),
                ),
              ],
            );
            final btn = PrimaryButton(
              label: 'Start an enquiry',
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
