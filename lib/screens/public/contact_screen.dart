import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  /// Form 1 — Corporate / general enquiry (Journey E)
  final _enquiryForm = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _org = TextEditingController();
  final _message = TextEditingController();
  String? _type = Brand.enquiryTypes.first;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _org.dispose();
    _message.dispose();
    super.dispose();
  }

  bool _prefilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prefilled) return;
    _prefilled = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      final type = '${args['type'] ?? ''}';
      if (Brand.enquiryTypes.contains(type)) _type = type;
      final topic = '${args['topic'] ?? ''}';
      if (topic.isNotEmpty) {
        _message.text = 'Hi MT Alchemy, I am interested in: $topic.\n\n';
      }
    }
  }

  void _submit() {
    final ok = _enquiryForm.currentState!.validate();
    if (ok) {
      AppState.instance.submitEnquiry(
        name: _name.text.trim(),
        email: _email.text.trim(),
        type: _type ?? Brand.enquiryTypes.first,
        message: _message.text.trim(),
      );
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.success),
              SizedBox(width: 10),
              Text('Enquiry sent'),
            ],
          ),
          content: Text(
            'Thank you, ${_name.text.trim()}. We aim to reply within 1 working day about your $_type enquiry. A copy is kept in this prototype session.',
            style: const TextStyle(height: 1.6),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _clear();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  void _clear() {
    _enquiryForm.currentState!.reset();
    _name.clear();
    _email.clear();
    _phone.clear();
    _org.clear();
    _message.clear();
    setState(() => _type = Brand.enquiryTypes.first);
  }

  @override
  Widget build(BuildContext context) {
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
                const Text('CONTACT',
                    style: TextStyle(
                        color: AppColors.softYellow,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        fontSize: 12)),
                const SizedBox(height: 14),
                Text(
                  'Let’s build a thriving workplace together.',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: Colors.white, fontSize: 42),
                ),
                const SizedBox(height: 14),
                Text(
                  'Tell us about your team, your challenge and your timeline — we will come back with a proposed outline.',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: .84),
                      fontSize: 16,
                      height: 1.6),
                ),
              ],
            ),
          ),
        ),
        Band(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: ResponsiveBuilder(
            builder: (context, type) {
              final form = _enquiryFormCard();
              final info = _contactCard();

              if (type == ScreenType.mobile) {
                return Column(children: [form, const SizedBox(height: 26), info]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: form),
                  const SizedBox(width: 32),
                  Expanded(flex: 5, child: info),
                ],
              );
            },
          ),
        ),
        const _QuickSignup(),
      ],
    );
  }

  Widget _enquiryFormCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _enquiryForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send an enquiry',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Fields marked * are required.',
                style: TextStyle(fontSize: 13.5)),
            const SizedBox(height: 22),
            ResponsiveBuilder(
              builder: (context, ts) {
                final half = ts != ScreenType.mobile;
                Widget row(List<Widget> children) => half
                    ? Row(
                        children: [
                          for (var i = 0; i < children.length; i++) ...[
                            if (i > 0) const SizedBox(width: 16),
                            Expanded(child: children[i]),
                          ],
                        ],
                      )
                    : Column(children: children);

                return Column(
                  children: [
                    row([
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                            labelText: 'Full name *',
                            prefixIcon: Icon(Icons.person_outline_rounded)),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Full name is required'
                            : null,
                      ),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email address *',
                            prefixIcon: Icon(Icons.mail_outline_rounded)),
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
                    ]),
                    const SizedBox(height: 16),
                    row([
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            labelText: 'Phone number',
                            prefixIcon: Icon(Icons.phone_outlined)),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          if (v.trim().length < 8) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _org,
                        decoration: const InputDecoration(
                            labelText: 'Organization',
                            prefixIcon: Icon(Icons.business_outlined)),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _type,
                      decoration: const InputDecoration(
                          labelText: 'Enquiry type *',
                          prefixIcon: Icon(Icons.category_outlined)),
                      items: [
                        for (final t in Brand.enquiryTypes)
                          DropdownMenuItem(value: t, child: Text(t)),
                      ],
                      onChanged: (v) => setState(() => _type = v),
                      validator: (v) =>
                          v == null ? 'Please select an enquiry type' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _message,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'How can we help? *',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.message_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Message is required';
                        }
                        if (v.trim().length < 15) {
                          return 'Please give us at least 15 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 14,
              runSpacing: 12,
              children: [
                PrimaryButton(
                  label: 'Submit enquiry',
                  icon: Icons.send_rounded,
                  onPressed: _submit,
                ),
                GhostButton(
                  label: 'Clear',
                  compact: true,
                  onPressed: _clear,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _contactCard() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.deepBlue, AppColors.indigo],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Talk to us directly',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 18),
              _ContactLine(
                  icon: Icons.phone_outlined,
                  label: 'WhatsApp',
                  value: Brand.phone),
              _ContactLine(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email',
                  value: Brand.email),
              _ContactLine(
                  icon: Icons.place_outlined,
                  label: 'Base',
                  value: Brand.address),
              _ContactLine(
                  icon: Icons.schedule_rounded,
                  label: 'Hours',
                  value: 'Mon–Fri, 9:00–18:00 (MYT)'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('What happens next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              for (final s in const [
                'We aim to acknowledge your enquiry within 1 working day.',
                'A 30-minute discovery call to understand your goals.',
                'You receive a proposed programme outline and quote.',
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          size: 18, color: AppColors.success),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(s,
                            style: const TextStyle(
                                fontSize: 14, height: 1.5)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFE8EEF7), Color(0xFFF6F8FC)],
            ),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_rounded, size: 40, color: AppColors.indigo),
              const SizedBox(height: 8),
              const Text('Nilai, Negeri Sembilan, Malaysia',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.ink)),
              const Text('Serving clients across Malaysia & Singapore',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              GhostButton(
                label: 'Copy address',
                compact: true,
                onPressed: () async {
                  await Clipboard.setData(
                      const ClipboardData(text: Brand.address));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Address copied to clipboard')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ContactLine(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: value));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label copied to clipboard')),
            );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 17, color: AppColors.softYellow),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label.toUpperCase(),
                      style: TextStyle(
                          fontSize: 10.5,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withValues(alpha: .7))),
                  const SizedBox(height: 3),
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600)),
                  const Text('Tap to copy',
                      style: TextStyle(
                          color: Colors.white60, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.copy_rounded,
                size: 15, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class _QuickSignup extends StatefulWidget {
  const _QuickSignup();

  @override
  State<_QuickSignup> createState() => _QuickSignupState();
}

class _QuickSignupState extends State<_QuickSignup> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Band(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 54),
      child: ResponsiveBuilder(
        builder: (context, type) {
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Not ready to talk yet?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text(
                'Join the monthly insight digest — practical tools for emotional intelligence at work.',
                style: TextStyle(height: 1.6),
              ),
            ],
          );

          final form = Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final field = TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Work email',
                    hintText: 'you@company.com',
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
                );
                final join = PrimaryButton(
                  label: 'Join',
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    final email = _email.text.trim();
                    final added = AppState.instance
                        .subscribeNewsletter(email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(added
                              ? 'You are on the list!'
                              : 'That email is already subscribed')),
                    );
                    if (added) _email.clear();
                  },
                );
                if (constraints.maxWidth < 420) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      field,
                      const SizedBox(height: 12),
                      join,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: field),
                    const SizedBox(width: 12),
                    join,
                  ],
                );
              },
            ),
          );

          if (type == ScreenType.mobile) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [copy, const SizedBox(height: 18), form],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 5, child: copy),
              const SizedBox(width: 40),
              Expanded(flex: 7, child: form),
            ],
          );
        },
      ),
    );
  }
}
