import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/bag_item.dart';
import '../models/category.dart';
import '../theme/design_tokens.dart';

/// EKRAN 4 — Özet / Paylaş.
/// Eksik (henüz işaretlenmemiş) maddeleri kategoriye göre listeler ve
/// düz metin olarak dışarı (WhatsApp, SMS, e-posta vb.) paylaşmaya izin verir.
class SummaryScreen extends StatelessWidget {
  final List<BagItem> items;

  const SummaryScreen({super.key, required this.items});

  List<BagItem> get _missingItems => items.where((i) => !i.isChecked).toList();

  String _buildShareText() {
    final buffer = StringBuffer('Doğum Çantası — Eksik Maddeler\n\n');
    for (final category in BagCategory.values) {
      final missingInCategory =
          _missingItems.where((i) => i.category == category).toList();
      if (missingInCategory.isEmpty) continue;
      buffer.writeln('${category.label}:');
      for (final item in missingInCategory) {
        final qtyPart = item.quantity > 1 ? ' (x${item.quantity})' : '';
        buffer.writeln('- ${item.name}$qtyPart');
      }
      buffer.writeln();
    }
    if (_missingItems.isEmpty) {
      buffer.writeln('Tüm maddeler hazır! 🎉');
    }
    return buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    final missing = _missingItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Özet')),
      body: missing.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Tebrikler! Tüm maddeler hazır. 🎉',
                  style: AppTypography.sectionHeader,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Text(
                  '${missing.length} eksik madde',
                  style: AppTypography.title,
                ),
                const SizedBox(height: AppSpacing.md),
                for (final category in BagCategory.values)
                  if (missing.any((i) => i.category == category)) ...[
                    Text(category.label, style: AppTypography.sectionHeader),
                    const SizedBox(height: AppSpacing.xs),
                    ...missing
                        .where((i) => i.category == category)
                        .map((i) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text('• ${i.name}${i.quantity > 1 ? ' (x${i.quantity})' : ''}',
                                  style: AppTypography.body),
                            )),
                    const SizedBox(height: AppSpacing.md),
                  ],
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Share.share(_buildShareText()),
        icon: const Icon(Icons.ios_share_outlined),
        label: const Text('Paylaş'),
      ),
    );
  }
}
