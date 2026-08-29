import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/bag_item.dart';
import '../models/category.dart';
import '../theme/design_tokens.dart';

/// EKRAN 2 — Madde Detayı.
/// Yeni madde ekleme, mevcut maddeyi düzenleme ve (varsa) hazır
/// listeden gelen maddeler için "neden gerekli" açıklamasını gösterir.
class ItemDetailScreen extends StatefulWidget {
  final BagItem? item;
  final BagCategory initialCategory;

  const ItemDetailScreen({
    super.key,
    this.item,
    required this.initialCategory,
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _noteController;
  late int _quantity;
  late BagCategory _category;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _noteController = TextEditingController(text: widget.item?.note ?? '');
    _quantity = widget.item?.quantity ?? 1;
    _category = widget.item?.category ?? widget.initialCategory;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final item = BagItem(
      id: widget.item?.id,
      name: _nameController.text.trim(),
      category: _category,
      quantity: _quantity,
      note: _noteController.text.trim(),
      isChecked: widget.item?.isChecked ?? false,
      whyNeeded: widget.item?.whyNeeded,
      sourceNote: widget.item?.sourceNote,
      isPreset: widget.item?.isPreset ?? false,
    );

    if (_isEditing) {
      await DbHelper.instance.updateItem(item);
    } else {
      await DbHelper.instance.insertItem(item);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Maddeyi Düzenle' : 'Yeni Madde')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ad'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Ad boş olamaz' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<BagCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: BagCategory.values
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v ?? _category),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Text('Adet', style: AppTypography.body),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                ),
                Text('$_quantity', style: AppTypography.sectionHeader),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Not (opsiyonel)'),
              maxLines: 2,
            ),
            if (item?.whyNeeded != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Neden gerekli?', style: AppTypography.sectionHeader),
                    const SizedBox(height: AppSpacing.xs),
                    Text(item!.whyNeeded!, style: AppTypography.body),
                    if (item.sourceNote != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text('Kaynak notu: ${item.sourceNote}',
                          style: AppTypography.caption),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _save,
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
