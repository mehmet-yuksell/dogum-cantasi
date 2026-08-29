import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// Liste ekranının üstünde gösterilen "18/34 hazır" ilerleme çubuğu.
class ProgressHeader extends StatelessWidget {
  final int checkedCount;
  final int totalCount;

  const ProgressHeader({
    super.key,
    required this.checkedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = totalCount == 0 ? 0.0 : checkedCount / totalCount;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Çanta durumu', style: AppTypography.sectionHeader),
              Text(
                '$checkedCount/$totalCount hazır',
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 10,
              backgroundColor: AppColors.divider,
              valueColor: const AlwaysStoppedAnimation(AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}
