import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _postcode = TextEditingController();
  String _country = 'Malaysia';
  String _payment = 'Card (Visa / Mastercard)';
  bool _processing = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    _city.dispose();
    _state.dispose();
    _postcode.dispose();
    super.dispose();
  }

  bool get _needsShipping => AppState.instance.cart.any((l) => !l.product.isDigital);

  void _pay() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _processing = true);
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      setState(() => _processing = false);
      final state = AppState.instance;
      final total = state.checkout();
      Navigator.pushReplacementNamed(context, '/confirmation',
          arguments: total);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    if (state.cart.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 70),
        child: EmptyState(
          icon: Icons.shopping_cart_outlined,
          title: 'Nothing to check out',
          message: 'Add a product to your cart first.',
          action: PrimaryButton(
              label: 'Go to store',
              onPressed: () => Navigator.pushNamed(context, '/store')),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: ResponsiveBuilder(
            builder: (context, type) {
              final form = Panel(
                title: 'Checkout',
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _StepLabel(
                          n: '1', label: 'Customer information'),
                      const SizedBox(height: 14),
                      _half([
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
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            labelText: 'Phone number *',
                            prefixIcon: Icon(Icons.phone_outlined)),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          if (v.trim().length < 8) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 26),
                      const _StepLabel(n: '2', label: 'Billing address'),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _address,
                        decoration: const InputDecoration(
                            labelText: 'Address line *',
                            prefixIcon: Icon(Icons.home_outlined)),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Address is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _half([
                        TextFormField(
                          controller: _city,
                          decoration:
                              const InputDecoration(labelText: 'City *'),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'City is required'
                              : null,
                        ),
                        TextFormField(
                          controller: _state,
                          decoration:
                              const InputDecoration(labelText: 'State *'),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'State is required'
                              : null,
                        ),
                      ]),
                      const SizedBox(height: 16),
                      _half([
                        TextFormField(
                          controller: _postcode,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Postcode *'),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Postcode is required';
                            }
                            if (v.trim().length < 4) {
                              return 'Enter a valid postcode';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          initialValue: _country,
                          decoration:
                              const InputDecoration(labelText: 'Country *'),
                          items: const [
                            DropdownMenuItem(
                                value: 'Malaysia', child: Text('Malaysia')),
                            DropdownMenuItem(
                                value: 'Singapore', child: Text('Singapore')),
                            DropdownMenuItem(
                                value: 'Brunei', child: Text('Brunei')),
                          ],
                          onChanged: (v) => setState(() => _country = v!),
                        ),
                      ]),
                      const SizedBox(height: 26),
                      _StepLabel(
                          n: '3',
                          label: _needsShipping
                              ? 'Shipping (physical items)'
                              : 'Shipping (not required)'),
                      const SizedBox(height: 14),
                      if (_needsShipping)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.bg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Text(
                            'Your order contains physical products — standard shipping of RM15 applies and a tracking number will be emailed after dispatch.',
                            style: TextStyle(fontSize: 13.5, height: 1.6),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.download_rounded,
                                  color: AppColors.success, size: 18),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'All items are digital — nothing to ship. Files unlock instantly after payment.',
                                  style: TextStyle(fontSize: 13.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 26),
                      const _StepLabel(n: '4', label: 'Payment'),
                      const SizedBox(height: 14),
                      for (final m in const [
                        'Card (Visa / Mastercard)',
                        'FPX Online Banking',
                        'e-Wallet (GrabPay / Touch \'n Go)',
                      ])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => setState(() => _payment = m),
                            child: AnimatedContainer(
                              duration: 180.ms,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: _payment == m
                                    ? AppColors.purpleSoft
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _payment == m
                                      ? AppColors.purple
                                      : AppColors.border,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    m.startsWith('Card')
                                        ? Icons.credit_card_rounded
                                        : m.startsWith('FPX')
                                            ? Icons.account_balance_rounded
                                            : Icons.account_balance_wallet_rounded,
                                    color: _payment == m
                                        ? AppColors.purple
                                        : AppColors.muted,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(m,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: _payment == m
                                                ? AppColors.ink
                                                : AppColors.muted)),
                                  ),
                                  if (_payment == m)
                                    const Icon(Icons.check_circle_rounded,
                                        color: AppColors.purple, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.verified_user_outlined,
                              size: 17, color: AppColors.success),
                          const SizedBox(width: 8),
                          Text(
                            'Payment states supported: Successful · Failed · Pending',
                            style: TextStyle(
                                fontSize: 12.5,
                                color: AppColors.muted.withValues(alpha: 1)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      PrimaryButton(
                        label: _processing
                            ? 'Processing payment…'
                            : 'Pay RM${state.total.toStringAsFixed(2)}',
                        icon: Icons.lock_rounded,
                        wide: true,
                        onPressed: _processing ? null : _pay,
                      ),
                      if (_processing) ...[
                        const SizedBox(height: 16),
                        const LinearProgressIndicator(),
                      ],
                    ],
                  ),
                ),
              );

              final summary = Panel(
                title: 'Your order',
                child: Column(
                  children: [
                    for (final l in state.cart)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          children: [
                            NetworkImg(
                              url: l.product.image,
                              width: 52,
                              height: 52,
                              radius: BorderRadius.circular(10),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l.product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14)),
                                  Text('${l.product.isDigital ? 'Digital' : 'Physical'} · qty ${l.qty}',
                                      style: const TextStyle(
                                          fontSize: 12.5,
                                          color: AppColors.muted)),
                                ],
                              ),
                            ),
                            Text('RM${(l.product.price * l.qty).toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    const Divider(),
                    const SizedBox(height: 12),
                    _SumRow(label: 'Subtotal', value: 'RM${state.subtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 10),
                    _SumRow(
                        label: 'Shipping',
                        value: state.shipping == 0
                            ? 'Free'
                            : 'RM${state.shipping.toStringAsFixed(2)}'),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 16)),
                        ),
                        Text('RM${state.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 21,
                                color: AppColors.deepBlue)),
                      ],
                    ),
                  ],
                ),
              );

              if (type != ScreenType.desktop) {
                return Column(
                    children: [summary, const SizedBox(height: 20), form]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: form),
                  const SizedBox(width: 22),
                  SizedBox(width: 360, child: summary),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _half(List<Widget> children) {
    if (isMobile(context)) {
      return Column(children: [
        children[0],
        const SizedBox(height: 16),
        children[1],
      ]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: children[0]),
        const SizedBox(width: 16),
        Expanded(child: children[1]),
      ],
    );
  }
}

class _StepLabel extends StatelessWidget {
  final String n;
  final String label;
  const _StepLabel({required this.n, required this.label});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.deepBlue,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(n,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 16)),
        ],
      );
}

class _SumRow extends StatelessWidget {
  final String label;
  final String value;
  const _SumRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      );
}
