import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../../widgets/portal_shell.dart';

class LearnerDashboardScreen extends StatefulWidget {
  const LearnerDashboardScreen({super.key});

  @override
  State<LearnerDashboardScreen> createState() => _LearnerDashboardScreenState();
}

class _LearnerDashboardScreenState extends State<LearnerDashboardScreen> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  final _profileKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: AppState.instance.userName ?? 'Learner');
    _email = TextEditingController(
        text: 'learner@mtalchemy.my');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final pct = (state.activeProgress * 100).round();
    final active = Content.courses
        .firstWhere((c) => c.id == state.activeCourseId,
            orElse: () => Content.courses.first);

    return PortalShell(
      title: 'Learner Dashboard',
      subtitle: 'Welcome back — pick up where you left off',
      activeRoute: '/dashboard',
      items: const [
        PortalNavItem('Overview', Icons.dashboard_rounded, '/dashboard'),
        PortalNavItem('Course player', Icons.play_circle_rounded, '/player'),
        PortalNavItem('Quiz / Assessment', Icons.quiz_rounded, '/quiz'),
        PortalNavItem('Certificate', Icons.workspace_premium_rounded, '/certificate'),
        PortalNavItem('Learning Hub', Icons.school_rounded, '/upskilling'),
        PortalNavItem('Store', Icons.storefront_rounded, '/store'),
        PortalNavItem('My orders', Icons.receipt_long_rounded, '/orders'),
        PortalNavItem('Digital library', Icons.download_rounded, '/digital-library'),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _continueCard(course: active, pct: pct),
          const SizedBox(height: 22),
          ResponsiveBuilder(
            builder: (context, type) {
              final tiles = [
                StatTile(
                    value: '${state.enrolled.length}',
                    label: 'Courses enrolled',
                    icon: Icons.menu_book_rounded,
                    accent: AppColors.deepBlue),
                StatTile(
                    value: '${state.enrolled.length - 1}',
                    label: 'In progress',
                    icon: Icons.timelapse_rounded,
                    accent: AppColors.purple),
                StatTile(
                    value: '${state.certificateIssued ? 1 : 0}',
                    label: 'Certificates earned',
                    icon: Icons.workspace_premium_rounded,
                    accent: AppColors.softYellow),
                StatTile(
                    value: '18h',
                    label: 'Learning hours',
                    icon: Icons.schedule_rounded,
                    accent: AppColors.teal),
              ];
              if (type == ScreenType.mobile) {
                return Column(
                  children: [
                    for (final t in tiles)
                      Padding(
                          padding: const EdgeInsets.only(bottom: 14), child: t),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < tiles.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    Expanded(child: tiles[i]),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          ResponsiveBuilder(
            builder: (context, type) {
              final learning = _myLearning(state);
              final side = Column(
                children: [
                  _achievements(),
                  const SizedBox(height: 20),
                  _profileForm(),
                ],
              );
              if (type != ScreenType.desktop) {
                return Column(children: [
                  learning,
                  const SizedBox(height: 22),
                  side,
                ]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: learning),
                  const SizedBox(width: 22),
                  Expanded(flex: 5, child: side),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          _ordersPanel(state),
        ],
      ),
    );
  }

  Widget _continueCard({required Course course, required int pct}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.deepBlue, Color(0xFF2A2F63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: ResponsiveBuilder(
        builder: (context, type) {
          final text = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome, ${AppState.instance.userName ?? 'Learner'}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Continue learning — you are almost there.',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: .8), fontSize: 15)),
              const SizedBox(height: 22),
              Tag(
                  label: course.category,
                  color: AppColors.softYellow),
              const SizedBox(height: 14),
              Text(course.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: pct / 100),
                        duration: 900.ms,
                        curve: Curves.easeOutCubic,
                        builder: (context, v, _) =>
                            LinearProgressIndicator(
                          value: v,
                          minHeight: 10,
                          backgroundColor: Colors.white.withValues(alpha: .2),
                          valueColor: const AlwaysStoppedAnimation(
                              AppColors.softYellow),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('$pct%',
                      style: const TextStyle(
                          color: AppColors.softYellow,
                          fontWeight: FontWeight.w800,
                          fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                children: [
                  PrimaryButton(
                    label: 'Continue Course',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => Navigator.pushNamed(context, '/player'),
                  ),
                  GhostButton(
                    label: 'Take the quiz',
                    compact: true,
                    onPressed: () => Navigator.pushNamed(context, '/quiz'),
                  ),
                ],
              ),
            ],
          );

          final ring = SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: pct / 100),
                  duration: 1000.ms,
                  curve: Curves.easeOutCubic,
                  builder: (context, v, _) => CircularProgressIndicator(
                    value: v,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withValues(alpha: .18),
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.softYellow),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$pct%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800)),
                      Text('complete',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: .7),
                              fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).scale(
              begin: const Offset(.9, .9),
              end: const Offset(1, 1),
              duration: 600.ms);

          if (type == ScreenType.mobile) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [text, const SizedBox(height: 26), Center(child: ring)]);
          }
          return Row(
            children: [
              Expanded(child: text),
              const SizedBox(width: 30),
              ring,
            ],
          );
        },
      ),
    );
  }

  Widget _myLearning(AppState state) {
    return Panel(
      title: 'My learning',
      trailing: TextButton(
        onPressed: () => Navigator.pushNamed(context, '/upskilling'),
        child: const Text('Browse more'),
      ),
      child: Column(
        children: [
          for (final id in state.enrolled)
            Builder(builder: (context) {
              final c = Content.courses.firstWhere((x) => x.id == id,
                  orElse: () => Content.courses.first);
              final p = id == state.activeCourseId
                  ? state.activeProgress
                  : 1.0;
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    NetworkImg(
                      url: c.image,
                      width: 64,
                      height: 64,
                      radius: BorderRadius.circular(12),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text('${c.modules} modules · ${c.duration}',
                              style: const TextStyle(
                                  fontSize: 12.5, color: AppColors.muted)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(99),
                                  child: LinearProgressIndicator(
                                    value: p,
                                    minHeight: 7,
                                    backgroundColor: AppColors.border,
                                    valueColor:
                                        const AlwaysStoppedAnimation(
                                            AppColors.purple),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text('${(p * 100).round()}%',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    PrimaryButton(
                      label: p >= 1 ? 'Review' : 'Continue',
                      compact: true,
                      onPressed: () {
                        state.openCourse(c.id);
                        Navigator.pushNamed(context, '/player');
                      },
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _achievements() {
    return Panel(
      title: 'Achievements',
      child: Column(
        children: [
          Row(
            children: [
              _badge(Icons.workspace_premium_rounded, AppColors.softYellow,
                  '${AppState.instance.certificateIssued ? 1 : 0}', 'Certificates'),
              const SizedBox(width: 12),
              _badge(Icons.emoji_events_rounded, AppColors.purple, '4',
                  'Completed lessons'),
              const SizedBox(width: 12),
              _badge(Icons.local_fire_department_rounded, AppColors.danger,
                  '6', 'Day streak'),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.purpleSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_rounded, size: 18, color: AppColors.purple),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Finish Module 5 and pass the quiz to unlock your certificate.',
                    style: TextStyle(fontSize: 13, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, Color c, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: c, size: 24),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 17)),
            Text(label,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 11.5, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }

  Widget _profileForm() {
    return Panel(
      title: 'Profile',
      child: Form(
        key: _profileKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
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
            DropdownButtonFormField<String>(
              initialValue: 'Emotional Intelligence',
              decoration: const InputDecoration(
                labelText: 'Preferred learning area',
                prefixIcon: Icon(Icons.favorite_outline_rounded),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'Emotional Intelligence',
                    child: Text('Emotional Intelligence')),
                DropdownMenuItem(
                    value: 'Leadership', child: Text('Leadership')),
                DropdownMenuItem(value: 'Mindfulness', child: Text('Mindfulness')),
                DropdownMenuItem(
                    value: 'Communication', child: Text('Communication')),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                PrimaryButton(
                  label: 'Save changes',
                  compact: true,
                  onPressed: () {
                    if (_profileKey.currentState!.validate()) {
                      AppState.instance.signIn(
                          name: _name.text.trim(),
                          role: AppState.instance.userRole);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated')),
                      );
                    }
                  },
                ),
                const SizedBox(width: 10),
                GhostButton(
                  label: 'Change password',
                  compact: true,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ordersPanel(AppState state) {
    return Panel(
      title: 'My orders',
      trailing: TextButton(
        onPressed: () => Navigator.pushNamed(context, '/orders'),
        child: const Text('View all'),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Order')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Items')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Status')),
          ],
          rows: [
            for (final o in state.orders)
              DataRow(cells: [
                DataCell(Text(o['id']!,
                    style: const TextStyle(fontWeight: FontWeight.w700))),
                DataCell(Text(o['date']!)),
                DataCell(SizedBox(
                    width: 320, child: Text(o['items']!, maxLines: 1))),
                DataCell(Text(o['amount']!)),
                DataCell(Tag(
                    label: o['status']!,
                    color: o['status'] == 'Paid'
                        ? AppColors.success
                        : AppColors.indigo)),
              ]),
          ],
        ),
      ),
    );
  }
}
