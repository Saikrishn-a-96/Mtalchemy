import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  int? _selected;
  final List<int?> _answers = List.filled(Content.quiz.length, null);
  bool _submitted = false;

  QuizQuestion get _q => Content.quiz[_index];

  int get _score {
    var s = 0;
    for (var i = 0; i < Content.quiz.length; i++) {
      if (_answers[i] == Content.quiz[i].correctIndex) s++;
    }
    return s;
  }

  void _next() {
    _answers[_index] = _selected;
    if (_index < Content.quiz.length - 1) {
      setState(() {
        _index++;
        _selected = _answers[_index];
      });
    } else {
      setState(() => _submitted = true);
      if (_score >= 4) AppState.instance.markLessonComplete(1.0);
    }
  }

  void _retake() {
    setState(() {
      _index = 0;
      _selected = null;
      _answers.fillRange(0, Content.quiz.length, null);
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: _submitted ? _result() : _question(),
        ),
      ),
    );
  }

  Widget _question() {
    final pct = (_index + 1) / Content.quiz.length;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepBlue.withValues(alpha: .07),
            blurRadius: 34,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Tag(label: 'QUIZ / ASSESSMENT', color: AppColors.purple),
              const SizedBox(width: 12),
              Text('Question ${_index + 1} of ${Content.quiz.length}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.muted)),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: pct),
              duration: 600.ms,
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 9,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation(AppColors.purple),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Text(_q.question,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, height: 1.4)),
          const SizedBox(height: 24),
          for (var i = 0; i < _q.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _selected = i),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selected == i
                        ? AppColors.purpleSoft
                        : AppColors.bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selected == i
                          ? AppColors.purple
                          : AppColors.border,
                      width: _selected == i ? 1.6 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selected == i
                              ? AppColors.purple
                              : Colors.white,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          String.fromCharCode(65 + i),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: _selected == i
                                ? Colors.white
                                : AppColors.muted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(_q.options[i],
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: _selected == i
                                    ? FontWeight.w700
                                    : FontWeight.w500)),
                      ),
                      if (_selected == i)
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.purple, size: 22),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          ResponsiveBuilder(
            builder: (context, type) {
              final nav = Row(
                children: [
                  if (_index > 0)
                    GhostButton(
                      label: 'Previous',
                      compact: true,
                      onPressed: () => setState(() {
                        _index--;
                        _selected = _answers[_index];
                      }),
                    ),
                  const SizedBox(width: 12),
                  PrimaryButton(
                    label: _index == Content.quiz.length - 1
                        ? 'Submit assessment'
                        : 'Next question',
                    icon: Icons.arrow_forward_rounded,
                    compact: true,
                    onPressed: _selected == null ? null : _next,
                  ),
                ],
              );
              if (type == ScreenType.mobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PrimaryButton(
                      label: _index == Content.quiz.length - 1
                          ? 'Submit assessment'
                          : 'Next question',
                      onPressed: _selected == null ? null : _next,
                      wide: true,
                    ),
                  ],
                );
              }
              return nav;
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 380.ms);
  }

  Widget _result() {
    final passed = _score >= 4;
    final total = Content.quiz.length;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepBlue.withValues(alpha: .07),
            blurRadius: 34,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: passed
                      ? AppColors.success.withValues(alpha: .15)
                      : AppColors.danger.withValues(alpha: .15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                  size: 38,
                  color: passed ? AppColors.success : AppColors.danger,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(passed ? 'Congratulations!' : 'Almost there',
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w800)),
                    Text(
                      passed
                          ? 'You passed the assessment and unlocked your certificate.'
                          : 'Score at least 4 out of 5 to pass. Review the lessons and try again.',
                      style: const TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppColors.deepBlue, AppColors.indigo]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: ResponsiveBuilder(
              builder: (context, type) {
                final score = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('True Score',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: .8),
                            fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('$_score / $total',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w800)),
                  ],
                );
                final bar = Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Passing mark: 4 / $total',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: .8),
                              fontSize: 13)),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: _score / total),
                          duration: 900.ms,
                          curve: Curves.easeOutCubic,
                          builder: (context, v, _) =>
                              LinearProgressIndicator(
                            value: v,
                            minHeight: 10,
                            backgroundColor:
                                Colors.white.withValues(alpha: .2),
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
                      children: [score, const SizedBox(height: 16), bar]);
                }
                return Row(
                  children: [score, const SizedBox(width: 30), bar],
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text('Answer review',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          for (var i = 0; i < Content.quiz.length; i++)
            Builder(builder: (context) {
              final q = Content.quiz[i];
              final correct = _answers[i] == q.correctIndex;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: correct
                          ? AppColors.success.withValues(alpha: .45)
                          : AppColors.danger.withValues(alpha: .45)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          correct
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: correct
                              ? AppColors.success
                              : AppColors.danger,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text('Q${i + 1}. ${q.question}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      correct
                          ? 'Your answer: ${q.options[_answers[i] ?? 0]} — correct'
                          : 'Your answer: ${_answers[i] == null ? 'not answered' : q.options[_answers[i]!]} · Correct: ${q.options[q.correctIndex]}',
                      style: TextStyle(
                          fontSize: 13.5,
                          color: correct
                              ? AppColors.success
                              : AppColors.danger,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text('Why — ${q.explanation}',
                        style: const TextStyle(
                            fontSize: 13.5, height: 1.55)),
                  ],
                ),
              );
            }),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            children: [
              PrimaryButton(
                label: passed ? 'View certificate' : 'Retake assessment',
                icon: passed
                    ? Icons.workspace_premium_rounded
                    : Icons.refresh_rounded,
                onPressed: passed
                    ? () => Navigator.pushNamed(context, '/certificate')
                    : _retake,
              ),
              GhostButton(
                label: 'Back to course',
                onPressed: () => Navigator.pushNamed(context, '/player'),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 420.ms);
  }
}
