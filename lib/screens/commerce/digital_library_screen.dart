import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class DigitalLibraryScreen extends StatelessWidget {
  const DigitalLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('My Digital Products',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text(
                'Access is verified against your purchase history — these files are not public links.',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 24),
              if (state.digitalLibrary.isEmpty)
                EmptyState(
                  icon: Icons.folder_off_outlined,
                  title: 'No digital products yet',
                  message:
                      'Buy a workbook or template pack and it will appear here instantly after payment.',
                  action: PrimaryButton(
                      label: 'Browse digital products',
                      onPressed: () => Navigator.pushNamed(context, '/store')),
                )
              else
                ResponsiveBuilder(
                  builder: (context, type) {
                    final cards = [
                      for (final item in state.digitalLibrary) item,
                    ];
                    Widget card(Map<String, String> item) => Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.deepBlue.withValues(alpha: .06),
                                blurRadius: 22,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: AppColors.purpleSoft,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(Icons.description_rounded,
                                        color: AppColors.purple, size: 26),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item['name']!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16.5)),
                                        const SizedBox(height: 4),
                                        Text('Purchased: ${item['purchased']}',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: AppColors.muted)),
                                      ],
                                    ),
                                  ),
                                  const Tag(
                                      label: 'VERIFIED',
                                      color: AppColors.success),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.bg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.lock_outline_rounded,
                                        size: 16, color: AppColors.success),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(item['file']!,
                                          style: const TextStyle(
                                              fontSize: 13)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  PrimaryButton(
                                    label: 'Download',
                                    icon: Icons.download_rounded,
                                    compact: true,
                                    onPressed: () => ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(SnackBar(
                                        content: Text(
                                            'Downloading ${item['name']}…'))),
                                  ),
                                  const SizedBox(width: 10),
                                  GhostButton(
                                    label: 'Preview',
                                    compact: true,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 420.ms);

                    final cross = type == ScreenType.mobile
                        ? 1
                        : type == ScreenType.tablet
                            ? 2
                            : 3;

                    if (cross == 1) {
                      return Column(
                        children: [
                          for (final item in cards)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child:
                                  SizedBox(width: double.infinity, child: card(item)),
                            ),
                        ],
                      );
                    }

                    final rows = <Widget>[];
                    for (var i = 0; i < cards.length; i += cross) {
                      final chunk = cards.skip(i).take(cross).toList();
                      rows.add(Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var j = 0; j < chunk.length; j++) ...[
                              if (j > 0) const SizedBox(width: 18),
                              Expanded(child: card(chunk[j])),
                            ],
                            if (chunk.length < cross)
                              for (var k = chunk.length; k < cross; k++)
                                const Expanded(child: SizedBox()),
                          ],
                        ),
                      ));
                    }
                    return Column(children: rows);
                  },
                ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.deepBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_rounded,
                        color: AppColors.softYellow, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Purchase verification: the server checks that your account owns this product before any download token is issued.',
                        style: TextStyle(
                            color: Colors.white, fontSize: 13.5, height: 1.55),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
