import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  bool _downloaded = false;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final course = Content.courses.firstWhere(
      (c) => c.id == state.activeCourseId,
      orElse: () => Content.courses.first,
    );
    final learner = state.userName ?? 'Learner Name';
    final issued = state.certificateIssued;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 940),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.deepBlue, Color(0xFF2A2F63)]),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: ResponsiveBuilder(
                  builder: (context, type) {
                    final txt = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issued ? 'Congratulations!' : 'Certificate preview',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          issued
                              ? 'You have completed all lessons and passed the assessment.'
                              : 'Complete the course and pass the assessment to issue your certificate.',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: .82),
                              fontSize: 15,
                              height: 1.6),
                        ),
                      ],
                    );
                    final btns = Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        PrimaryButton(
                          label: 'Download Certificate',
                          icon: Icons.download_rounded,
                          onPressed: issued
                              ? () => setState(() => _downloaded = true)
                              : null,
                        ),
                        GhostButton(
                          label: 'Share',
                          compact: true,
                          onPressed: issued ? () {} : null,
                        ),
                      ],
                    );

                    if (type == ScreenType.mobile) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [txt, const SizedBox(height: 18), btns]);
                    }
                    return Row(
                      children: [
                        Expanded(child: txt),
                        const SizedBox(width: 24),
                        btns,
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 26),
              _certificateCard(
                learner: learner,
                course: course.title,
                issued: issued,
              ),
              const SizedBox(height: 20),
              if (_downloaded && issued)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: AppColors.success.withValues(alpha: .4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: AppColors.success),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Certificate PDF generated — MT-ALC-2026-0148.pdf saved to your downloads.',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                children: [
                  GhostButton(
                    label: 'Back to dashboard',
                    onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                  ),
                  GhostButton(
                    label: 'Browse more courses',
                    onPressed: () => Navigator.pushNamed(context, '/upskilling'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _certificateCard({
    required String learner,
    required String course,
    required bool issued,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.softYellow, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepBlue.withValues(alpha: .1),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.workspace_premium_rounded,
                  color: AppColors.softYellow, size: 40),
              SizedBox(width: 12),
              Text('MT ALCHEMY',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                      color: AppColors.deepBlue)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('CERTIFICATE OF COMPLETION',
              style: TextStyle(
                  fontSize: 13,
                  letterSpacing: 3.2,
                  fontWeight: FontWeight.w800,
                  color: AppColors.purple)),
          const SizedBox(height: 26),
          Text('This is to certify that',
              style: TextStyle(
                  color: AppColors.muted.withValues(alpha: .9), fontSize: 14)),
          const SizedBox(height: 12),
          Text(
            learner,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 14),
          const Text('has successfully completed the programme',
              style: TextStyle(color: AppColors.muted, fontSize: 14)),
          const SizedBox(height: 12),
          Text(
            course,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: AppColors.deepBlue,
            ),
          ),
          const SizedBox(height: 30),
          ResponsiveBuilder(
            builder: (context, type) {
              final meta = Expanded(
                child: Column(
                  children: const [
                    _Meta(label: 'Completion date', value: '12 October 2026'),
                    SizedBox(height: 18),
                    _Meta(label: 'Certificate ID', value: 'MT-ALC-2026-0148'),
                  ],
                ),
              );
              final trainer = Expanded(
                child: Column(
                  children: const [
                    _Meta(label: 'Trainer / Instructor', value: 'Mabel Tan KH'),
                    SizedBox(height: 18),
                    _Meta(
                        label: 'Issuing organisation',
                        value: 'MT Alchemy · Kaedae Event Management'),
                  ],
                ),
              );
              if (type == ScreenType.mobile) {
                return Column(children: [
                  meta,
                  const SizedBox(height: 18),
                  trainer,
                ]);
              }
              return Row(
                children: [
                  meta,
                  _qrPlaceholder(),
                  trainer,
                ],
              );
            },
          ),
          const SizedBox(height: 26),
          Divider(color: AppColors.border),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('mabeltan.alchemy@gmail.com',
                  style: TextStyle(fontSize: 12, color: AppColors.muted)),
              Text(
                issued
                    ? 'Verified digitally · scan QR to validate'
                    : 'Preview only — issue after passing the quiz',
                style: TextStyle(
                    fontSize: 12,
                    color: issued ? AppColors.success : AppColors.muted,
                    fontWeight: FontWeight.w600),
              ),
              const Text('www.mtalchemy.my',
                  style: TextStyle(fontSize: 12, color: AppColors.muted)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 520.ms).scale(
        begin: const Offset(.98, .98),
        end: const Offset(1, 1),
        duration: 520.ms,
        curve: Curves.easeOutCubic);
  }

  Widget _qrPlaceholder() {
    // Deterministic pseudo-QR block for the prototype.
    const pattern = [
      [1,1,1,1,1,0,1,0,1,1,1,1,1],
      [1,0,0,0,1,0,0,1,1,0,0,0,1],
      [1,0,1,0,1,1,1,0,1,0,1,0,1],
      [1,0,0,0,1,0,1,1,1,0,0,0,1],
      [1,1,1,1,1,0,1,0,1,1,1,1,1],
      [0,0,0,0,0,1,0,1,0,0,0,0,0],
      [1,0,1,1,1,0,1,1,0,1,1,0,1],
      [0,1,0,1,0,1,0,0,1,0,1,1,0],
      [1,1,1,1,1,0,1,1,0,1,0,1,1],
      [1,0,0,0,1,1,0,1,1,0,1,0,0],
      [1,0,1,0,1,0,1,0,0,1,1,1,0],
      [1,0,0,0,1,1,1,0,1,0,0,1,1],
      [1,1,1,1,1,0,0,1,1,1,0,0,1],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final row in pattern)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final c in row)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.all(.5),
                      color: c == 1 ? AppColors.ink : Colors.transparent,
                    ),
                ],
              ),
            const SizedBox(height: 6),
            const Text('SCAN TO VERIFY',
                style: TextStyle(
                    fontSize: 7.5,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w800,
                    color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final String label;
  final String value;
  const _Meta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(label.toUpperCase(),
              style: const TextStyle(
                  fontSize: 10.5,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w800,
                  color: AppColors.muted)),
          const SizedBox(height: 6),
          Text(value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink)),
        ],
      );
}
