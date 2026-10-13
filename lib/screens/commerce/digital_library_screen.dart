import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/brand_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class DigitalLibraryScreen extends StatelessWidget {
  const DigitalLibraryScreen({super.key});

  void _preview(BuildContext context, Map<String, String> item) {
    final name = item['name'] ?? 'Digital product';
    final purchased = item['purchased'] ?? '—';
    final file = item['file'] ?? 'Digital download';
    final match = Content.products.where((p) => p.name == name);
    final blurb = match.isEmpty ? null : match.first.blurb;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Tag(label: 'VERIFIED PURCHASE', color: AppColors.success),
            const SizedBox(height: 12),
            if (blurb != null)
              Text(blurb, style: const TextStyle(height: 1.6, fontSize: 14)),
            const SizedBox(height: 12),
            Text('Purchased: $purchased\nFormat: $file',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.muted, height: 1.6)),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _download(
      BuildContext context, Map<String, String> item) async {
    final name = item['name'] ?? 'Digital product';
    final ref =
        'MT-ALC-DL-${name.hashCode.abs().toString().padLeft(6, '0')}';
    await Clipboard.setData(
        ClipboardData(text: 'Download reference for “$name”: $ref'));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Download reference copied ($ref). Files ship with the full release — prototype.')),
      );
    }
  }

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
                    Widget card(Map<String, String> item) {
                      final name = item['name'] ?? 'Digital product';
                      final purchased = item['purchased'] ?? '—';
                      final file = item['file'] ?? 'Digital download';
                      return Container(
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
                          mainAxisSize: MainAxisSize.min,
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
                                      Text(name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16.5)),
                                      const SizedBox(height: 4),
                                      Text('Purchased: $purchased',
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
                                    child: Text(file,
                                        style: const TextStyle(
                                            fontSize: 13)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                PrimaryButton(
                                  label: 'Download',
                                  icon: Icons.download_rounded,
                                  compact: true,
                                  onPressed: () => _download(context, item),
                                ),
                                GhostButton(
                                  label: 'Preview',
                                  compact: true,
                                  onPressed: () => _preview(context, item),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 420.ms);
                    }

                    final perRow = type == ScreenType.mobile
                        ? 1
                        : type == ScreenType.tablet
                            ? 2
                            : 3;
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        const gap = 18.0;
                        final w = constraints.maxWidth;
                        final itemW = perRow == 1
                            ? w
                            : (w - gap * (perRow - 1)) / perRow;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final item in cards)
                              SizedBox(width: itemW, child: card(item)),
                          ],
                        );
                      },
                    );
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
