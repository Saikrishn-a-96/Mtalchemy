import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class CoursePlayerScreen extends StatefulWidget {
  const CoursePlayerScreen({super.key});

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen> {
  int _module = 2;
  int _contentTab = 0;

  static const _lessons = [
    ('What Emotional Intelligence Really Is', 'video', 14),
    ('Self-Awareness & Trigger Mapping', 'video', 18),
    ('Regulation Under Pressure', 'video', 16),
    ('Empathy & Social Skills', 'pdf', 12),
    ('EQ at Work: Practice Lab', 'quiz', 20),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final course = Content.courses.firstWhere(
      (c) => c.id == state.activeCourseId,
      orElse: () => Content.courses.first,
    );
    final pct = (state.activeProgress * 100).round();
    final narrow = isMobile(context);

    return Column(
      children: [
        _topBar(course: course, pct: pct, state: state),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ResponsiveBuilder(
            builder: (context, type) {
              final sidebar = _moduleList(course, narrow);
              final content = _contentArea(course, state, narrow);

              if (type == ScreenType.mobile) {
                return Column(children: [sidebar, const SizedBox(height: 18), content]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 320, child: sidebar),
                  const SizedBox(width: 22),
                  Expanded(child: content),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _topBar(
      {required Course course, required int pct, required AppState state}) {
    return Container(
      width: double.infinity,
      color: AppColors.deepBlue,
      child: PageWidth(
        max: 1400,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        child: ResponsiveBuilder(
          builder: (context, type) {
            final info = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/upskilling'),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_rounded,
                          size: 17, color: AppColors.softYellow),
                      SizedBox(width: 6),
                      Text('Learning Hub',
                          style: TextStyle(
                              color: AppColors.softYellow,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(course.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('Module ${_module + 1} · ${_lessons[_module].$1}',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: .75),
                        fontSize: 13.5)),
              ],
            );

            final progress = ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Course Progress: $pct%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5)),
                      Text('${_module + 1} / ${_lessons.length} lessons',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: .7),
                              fontSize: 12.5)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: state.activeProgress),
                      duration: 800.ms,
                      curve: Curves.easeOutCubic,
                      builder: (context, v, _) => LinearProgressIndicator(
                        value: v,
                        minHeight: 9,
                        backgroundColor: Colors.white.withValues(alpha: .2),
                        valueColor: const AlwaysStoppedAnimation(
                            AppColors.softYellow),
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (type == ScreenType.mobile) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [info, const SizedBox(height: 16), progress]);
            }
            return Row(
              children: [
                Expanded(child: info),
                const SizedBox(width: 30),
                progress,
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _moduleList(Course course, bool narrow) {
    return Panel(
      title: 'Course modules',
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (var i = 0; i < _lessons.length; i++)
            Builder(builder: (context) {
              final lesson = _lessons[i];
              final done = i < _module;
              final current = i == _module;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => _module = i),
                child: AnimatedContainer(
                  duration: 200.ms,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: current
                        ? AppColors.purpleSoft
                        : AppColors.bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: current
                          ? AppColors.purple.withValues(alpha: .45)
                          : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: done
                              ? AppColors.success
                              : current
                                  ? AppColors.purple
                                  : AppColors.border,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          done
                              ? Icons.check_rounded
                              : lesson.$2 == 'quiz'
                                  ? Icons.quiz_rounded
                                  : lesson.$2 == 'pdf'
                                      ? Icons.description_rounded
                                      : Icons.play_arrow_rounded,
                          size: 16,
                          color: done || current
                              ? Colors.white
                              : AppColors.muted,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lesson.$1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: current
                                        ? AppColors.ink
                                        : AppColors.ink)),
                            const SizedBox(height: 3),
                            Text(
                              '${lesson.$2.toUpperCase()} · ${lesson.$3} min',
                              style: const TextStyle(
                                  fontSize: 11.5, color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                      if (current)
                        const Icon(Icons.chevron_right_rounded,
                            color: AppColors.purple),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 6),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'The workbook PDF ships with the full release — lessons and quizzes work in this prototype.')),
            ),
            child: const Row(
              children: [
                Icon(Icons.download_rounded,
                    size: 17, color: AppColors.muted),
                SizedBox(width: 8),
                Text('Download workbook (PDF)',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepBlue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentArea(Course course, AppState state, bool narrow) {
    final lesson = _lessons[_module];
    final isQuiz = lesson.$2 == 'quiz';

    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: narrow ? 210 : 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF16375C), Color(0xFF3E2E6B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                NetworkImg(
                  url: course.image,
                  width: double.infinity,
                  height: double.infinity,
                  radius: BorderRadius.circular(16),
                  fit: BoxFit.cover,
                ).animate().fadeIn(duration: 600.ms),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .35),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 74,
                        height: 74,
                        decoration: BoxDecoration(
                          color: AppColors.softYellow,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .3),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.play_arrow_rounded,
                            size: 42, color: AppColors.deepBlue),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        isQuiz ? 'Assessment · 5 questions' : 'Video lesson',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 14,
                  bottom: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('04:12 / ${lesson.$3}:00',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              for (var i = 0; i < const ['Video', 'Transcript', 'PDF notes', 'Discussion'].length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(const [
                      'Video',
                      'Transcript',
                      'PDF notes',
                      'Discussion'
                    ][i]),
                    selected: _contentTab == i,
                    selectedColor: AppColors.deepBlue,
                    labelStyle: TextStyle(
                      color:
                          _contentTab == i ? Colors.white : AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                    onSelected: (_) => setState(() => _contentTab = i),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(lesson.$1,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(
            _contentTab == 0
                ? 'In this lesson you will practise naming the emotion, locating it in the body, and choosing a deliberate response instead of a reactive one. Follow along with the workbook on page 12.'
                : _contentTab == 1
                    ? 'Full transcript of the lesson, useful for review and accessibility. Transcript text is searchable across the course.'
                    : _contentTab == 2
                        ? 'Downloadable workbook section with reflection prompts, trigger maps and a weekly practice tracker.'
                        : 'Ask questions and share reflections with your cohort and facilitator.',
            style: const TextStyle(height: 1.7, fontSize: 15),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_rounded, color: AppColors.warning, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Practice: write down one trigger you noticed this week and the response you chose instead.',
                    style: TextStyle(fontSize: 13.5, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ResponsiveBuilder(
            builder: (context, type) {
              final prev = GhostButton(
                label: 'Previous',
                icon: Icons.arrow_back_rounded,
                onPressed: _module == 0
                    ? null
                    : () => setState(() => _module -= 1),
              );
              final done = PrimaryButton(
                label: 'Mark Complete',
                icon: Icons.check_rounded,
                onPressed: () {
                  final next =
                      ((_module + 1) / _lessons.length).clamp(0.0, 1.0);
                  state.markLessonComplete(
                      next > state.activeProgress ? next : state.activeProgress);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lesson marked complete')),
                  );
                  if (_module < _lessons.length - 1) {
                    setState(() => _module += 1);
                  } else {
                    Navigator.pushNamed(context, '/quiz');
                  }
                },
              );
              final next = GhostButton(
                label: 'Next',
                icon: Icons.arrow_forward_rounded,
                onPressed: _module == _lessons.length - 1
                    ? null
                    : () => setState(() => _module += 1),
              );

              if (type == ScreenType.mobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [prev, const SizedBox(height: 10), done, const SizedBox(height: 10), next],
                );
              }
              return Row(
                children: [
                  prev,
                  const SizedBox(width: 12),
                  done,
                  const SizedBox(width: 12),
                  next,
                  const Spacer(),
                  GhostButton(
                    label: 'Take quiz',
                    compact: true,
                    onPressed: () => Navigator.pushNamed(context, '/quiz'),
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
