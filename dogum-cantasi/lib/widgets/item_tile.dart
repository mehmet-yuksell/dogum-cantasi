import 'package:flutter/material.dart';
import '../models/bag_item.dart';
import '../models/category.dart';
import '../theme/design_tokens.dart';

/// Liste ekranındaki tek satırlık madde görünümü.
class ItemTile extends StatelessWidget {
  final BagItem item;
  final ValueChanged<bool?> onCheckedChanged;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ItemTile({
    super.key,
    required this.item,
    required this.onCheckedChanged,
    required this.onTap,
    required this.onDelete,
  });

  Color _categoryColor() {
    switch (item.category) {
      case BagCategory.anne:
        return AppColors.categoryAnne;
      case BagCategory.bebek:
        return AppColors.categoryBebek;
      case BagCategory.evrak:
        return AppColors.categoryEvrak;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          leading: Checkbox(
            value: item.isChecked,
            onChanged: onCheckedChanged,
            activeColor: AppColors.success,
          ),
          title: Text(
            item.name,
            style: AppTypography.body.copyWith(
              decoration: item.isChecked ? TextDecoration.lineThrough : null,
              color: item.isChecked
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
            ),
          ),
          subtitle: item.quantity > 1
              ? Text('Adet: ${item.quantity}', style: AppTypography.caption)
              : null,
          trailing: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _categoryColor(),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
