import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String _accountType = 'Individual';
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _phone = TextEditingController();
  final _orgName = TextEditingController();
  final _regNo = TextEditingController();
  String? _country = 'Malaysia';
  String? _industry;
  final List<String> _interests = [];
  bool _obscure = true;

  static const _countries = ['Malaysia', 'Singapore', 'Indonesia', 'Thailand', 'Brunei', 'Other'];
  static const _industries = ['Technology', 'Manufacturing', 'Financial Services', 'Education', 'Healthcare', 'Government', 'Other'];
  static const _interestAreas = [
    'Emotional Intelligence',
    'Leadership',
    'Mindfulness',
    'Communication',
    'Team Effectiveness',
    'Well-being',
  ];

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _phone.dispose();
    _orgName.dispose();
    _regNo.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final isOrg = _accountType == 'Organization';
    final displayName = isOrg
        ? _contact.text.trim()
        : _name.text.trim();
    final role = isOrg ? 'Employer' : 'Individual Learner';
    final route = isOrg ? '/employer' : '/dashboard';
    AppState.instance.signIn(name: displayName, role: role);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.success),
            SizedBox(width: 10),
            Text('Account created'),
          ],
        ),
        content: Text(
          isOrg
              ? 'Welcome, $displayName! Your organization workspace is ready — invite employees and assign courses.'
              : 'Welcome, $displayName! Your learner account is ready — pick up a course from the Learning Hub.',
          style: const TextStyle(height: 1.6),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, route, (r) => false),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final narrow = isMobile(context);

    return Container(
      width: double.infinity,
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepBlue.withValues(alpha: .08),
                  blurRadius: 40,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: narrow
                ? Column(children: [_aside(), _formBody()])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: _aside()),
                      Expanded(flex: 7, child: _formBody()),
                    ],
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 480.ms);
  }

  Widget _aside() {
    return Container(
      padding: const EdgeInsets.all(34),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.deepBlue, Color(0xFF2A2F63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('JOIN MT ALCHEMY',
              style: TextStyle(
                  color: AppColors.softYellow,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 12)),
          const SizedBox(height: 16),
          Text(
            'Create your account and start learning',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white, fontSize: 28),
          ),
          const SizedBox(height: 16),
          Text(
            'Register as an individual learner, or as an organization to manage employees and assign courses.',
            style: TextStyle(
                color: Colors.white.withValues(alpha: .82),
                fontSize: 14.5,
                height: 1.65),
          ),
          const SizedBox(height: 26),
          for (final b in const [
            'Access the Learning Hub and course player',
            'Earn certificates on completion',
            'Buy digital & physical learning tools',
            'Employers: assign courses and track progress',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.softYellow, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(b,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: .9),
                            fontSize: 14)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 26),
          Text(
            'Already have an account?',
            style: TextStyle(color: Colors.white.withValues(alpha: .8)),
          ),
          const SizedBox(height: 8),
          GhostButton(
            label: 'Sign in instead',
            compact: true,
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 13.5)),
      );

  Widget _formBody() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Register',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('All fields marked * are required.',
                  style: TextStyle(fontSize: 13.5)),
              const SizedBox(height: 22),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                      value: 'Individual',
                      label: Text('Individual'),
                      icon: Icon(Icons.person_outline_rounded)),
                  ButtonSegment(
                      value: 'Organization',
                      label: Text('Organization'),
                      icon: Icon(Icons.business_outlined)),
                ],
                selected: {_accountType},
                onSelectionChanged: (s) =>
                    setState(() => _accountType = s.first),
              ),
              const SizedBox(height: 24),
              if (_accountType == 'Individual') ...[
                _fieldLabel('Full name *'),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                      hintText: 'e.g. Aisyah Rahman',
                      prefixIcon: Icon(Icons.person_outline_rounded)),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
              ] else ...[
                _fieldLabel('Organization name *'),
                TextFormField(
                  controller: _orgName,
                  decoration: const InputDecoration(
                      hintText: 'e.g. ABC Sdn Bhd',
                      prefixIcon: Icon(Icons.business_outlined)),
                  validator: (v) => _accountType == 'Organization' &&
                          (v == null || v.trim().isEmpty)
                      ? 'Organization name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                _fieldLabel('Company registration number *'),
                TextFormField(
                  controller: _regNo,
                  decoration: const InputDecoration(
                      hintText: '202601234567 (SSM)',
                      prefixIcon: Icon(Icons.numbers_rounded)),
                  validator: (v) => _accountType == 'Organization' &&
                          (v == null || v.trim().isEmpty)
                      ? 'Registration number is required'
                      : null,
                ),
                const SizedBox(height: 16),
                _fieldLabel('Contact person *'),
                TextFormField(
                  controller: _contact,
                  decoration: const InputDecoration(
                      hintText: 'e.g. Tan Wei Ming',
                      prefixIcon: Icon(Icons.person_outline_rounded)),
                  validator: (v) => _accountType == 'Organization' &&
                          (v == null || v.trim().isEmpty)
                      ? 'Contact person is required'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _industry,
                  decoration: const InputDecoration(
                      labelText: 'Industry *',
                      prefixIcon: Icon(Icons.corporate_fare_rounded)),
                  items: [
                    for (final i in _industries)
                      DropdownMenuItem(value: i, child: Text(i)),
                  ],
                  onChanged: (v) => setState(() => _industry = v),
                  validator: (v) =>
                      v == null ? 'Please select an industry' : null,
                ),
              ],
              const SizedBox(height: 16),
              _fieldLabel('Email address *'),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'you@example.com',
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
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: 260,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel('Password *'),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            hintText: 'Minimum 8 characters',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Password is required';
                            }
                            if (v.length < 8) {
                              return 'Use at least 8 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 260,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel('Confirm password *'),
                        TextFormField(
                          controller: _confirm,
                          obscureText: _obscure,
                          decoration: const InputDecoration(
                            hintText: 'Repeat password',
                            prefixIcon: Icon(Icons.lock_reset_rounded),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Confirm your password';
                            }
                            if (v != _password.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: 260,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel('Phone number'),
                        TextFormField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              hintText: '+60 12-345 6789',
                              prefixIcon: Icon(Icons.phone_outlined)),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return null;
                            }
                            if (v.trim().length < 8) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel('Country *'),
                        DropdownButtonFormField<String>(
                          initialValue: _country,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.public_rounded)),
                          items: [
                            for (final c in _countries)
                              DropdownMenuItem(value: c, child: Text(c)),
                          ],
                          onChanged: (v) => setState(() => _country = v),
                          validator: (v) =>
                              v == null ? 'Please select a country' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _fieldLabel(_accountType == 'Individual'
                  ? 'Preferred learning areas'
                  : 'What should we focus on?'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final a in _interestAreas)
                    FilterChip(
                      label: Text(a),
                      selected: _interests.contains(a),
                      selectedColor: AppColors.purpleSoft,
                      checkmarkColor: AppColors.purple,
                      onSelected: (sel) => setState(() {
                        sel ? _interests.add(a) : _interests.remove(a);
                      }),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 14,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  PrimaryButton(
                    label: 'Create account',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _submit,
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('I already have an account'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Prototype note: accounts are stored in memory only — no data leaves this device.',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
