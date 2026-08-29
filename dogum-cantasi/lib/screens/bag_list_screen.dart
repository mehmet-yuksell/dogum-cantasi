import 'package:flutter/material.dart';

import '../data/db_helper.dart';
import '../models/bag_item.dart';
import '../models/category.dart';
import '../theme/design_tokens.dart';
import '../widgets/item_tile.dart';
import '../widgets/progress_header.dart';
import 'item_detail_screen.dart';
import 'reminder_screen.dart';
import 'summary_screen.dart';

/// EKRAN 1 — Çanta Listesi.
/// Üç kategori (Anne/Bebek/Evrak) sekmeli olarak gösterilir,
/// üstte genel ilerleme ("18/34 hazır") yer alır.
class BagListScreen extends StatefulWidget {
  const BagListScreen({super.key});

  @override
  State<BagListScreen> createState() => _BagListScreenState();
}

class _BagListScreenState extends State<BagListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<BagItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: BagCategory.values.length, vsync: this);
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await DbHelper.instance.getAllItems();
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  List<BagItem> _itemsFor(BagCategory category) =>
      _items.where((i) => i.category == category).toList();

  Future<void> _toggleChecked(BagItem item, bool? value) async {
    await DbHelper.instance.setChecked(item.id!, value ?? false);
    _loadItems();
  }

  Future<void> _deleteItem(BagItem item) async {
    await DbHelper.instance.deleteItem(item.id!);
    _loadItems();
  }

  Future<void> _openDetail({BagItem? item, BagCategory? presetCategory}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ItemDetailScreen(
          item: item,
          initialCategory: presetCategory ?? item?.category ?? _tabController.index.toBagCategory,
        ),
      ),
    );
    if (result == true) _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    final total = _items.length;
    final checked = _items.where((i) => i.isChecked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doğum Çantası'),
        actions: [
          IconButton(
            tooltip: 'Hatırlatıcı',
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReminderScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Özet / Paylaş',
            icon: const Icon(Icons.ios_share_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SummaryScreen(items: _items)),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryDark,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: BagCategory.values.map((c) => Tab(text: c.label)).toList(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ProgressHeader(checkedCount: checked, totalCount: total),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: BagCategory.values.map((category) {
                      final categoryItems = _itemsFor(category);
                      if (categoryItems.isEmpty) {
                        return Center(
                          child: Text(
                            'Bu kategoride henüz madde yok.',
                            style: AppTypography.caption,
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                        itemCount: categoryItems.length,
                        itemBuilder: (context, index) {
                          final item = categoryItems[index];
                          return ItemTile(
                            item: item,
                            onCheckedChanged: (v) => _toggleChecked(item, v),
                            onTap: () => _openDetail(item: item),
                            onDelete: () => _deleteItem(item),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDetail(presetCategory: _tabController.index.toBagCategory),
        icon: const Icon(Icons.add),
        label: const Text('Madde ekle'),
      ),
    );
  }
}

extension on int {
  BagCategory get toBagCategory => BagCategory.values[this];
}
