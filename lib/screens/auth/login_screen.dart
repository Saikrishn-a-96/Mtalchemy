import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _role = 'Individual Learner';
  bool _obscure = true;
  bool _remember = true;

  static const _roles = [
    'Individual Learner',
    'Employer',
    'Trainer',
    'Administrator',
  ];

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final name = _email.text.split('@').first.replaceAll('.', ' ');
    final pretty = name
        .split(' ')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
    AppState.instance.signIn(name: pretty, role: _role);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login Success — Welcome, $pretty')),
    );

    final route = switch (_role) {
      'Employer' => '/employer',
      'Administrator' => '/admin',
      'Trainer' => '/employer',
      _ => '/dashboard',
    };
    Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final narrow = isMobile(context);

    return Container(
      width: double.infinity,
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 940),
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
                ? Column(children: [_visual(), _form()])
                : IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 6, child: _visual()),
                        Expanded(flex: 6, child: _form()),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 460.ms);
  }

  Widget _visual() {
    return Container(
      padding: const EdgeInsets.all(34),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3E2E6B), AppColors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('WELCOME BACK',
              style: TextStyle(
                  color: AppColors.softYellow,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 12)),
          const SizedBox(height: 16),
          Text(
            'Continue your learning journey',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white, fontSize: 28),
          ),
          const SizedBox(height: 16),
          Text(
            'Sign in to access courses, certificates, your orders — or your organization dashboard.',
            style: TextStyle(
                color: Colors.white.withValues(alpha: .85),
                fontSize: 14.5,
                height: 1.65),
          ),
          const SizedBox(height: 26),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Demo accounts',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14)),
                SizedBox(height: 10),
                Text('Individual → learner@mtalchemy.my',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text('Employer → hr@abcsdn.my',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text('Admin → admin@mtalchemy.my',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text('Password → any 8+ characters',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const Spacer(),
          GhostButton(
            label: 'Create an account',
            compact: true,
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/register'),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    return Padding(
      padding: const EdgeInsets.all(34),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sign in',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Access your MT Alchemy account.',
                style: TextStyle(fontSize: 14)),
            const SizedBox(height: 26),
            const Text('Sign in as',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13.5)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in _roles)
                  ChoiceChip(
                    label: Text(r),
                    selected: _role == r,
                    selectedColor: AppColors.deepBlue,
                    labelStyle: TextStyle(
                      color: _role == r ? Colors.white : AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                    onSelected: (_) => setState(() => _role = r),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Email address',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13.5)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'you@example.com',
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
            const SizedBox(height: 18),
            const Text('Password',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13.5)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(_obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 8) return 'Use at least 8 characters';
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _remember,
                  onChanged: (v) => setState(() => _remember = v ?? false),
                ),
                const Text('Remember me',
                    style: TextStyle(fontSize: 13.5)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            PrimaryButton(
              label: 'Sign in',
              icon: Icons.login_rounded,
              wide: true,
              onPressed: _submit,
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/register'),
                child: const Text('New here? Create an account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
