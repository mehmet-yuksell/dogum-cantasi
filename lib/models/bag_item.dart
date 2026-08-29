import 'category.dart';

/// Çanta listesindeki tek bir madde.
///
/// [whyNeeded] ve [sourceNote] alanları hazır (seed) maddeler için
/// doldurulur; kullanıcının kendi eklediği maddelerde boş kalabilir.
class BagItem {
  final int? id;
  final String name;
  final BagCategory category;
  final int quantity;
  final String note;
  final bool isChecked;
  final String? whyNeeded;

  /// İçerik kaynağı hakkında şeffaflık notu. Bu proje için canlı web
  /// erişimi ile doğrulanmış tekil kaynaklar (URL) toplanamadığından,
  /// her hazır madde ya "genel/yaygın öneri" ya da "Türkiye'de hastane
  /// uygulamasında yaygın" olarak etiketlenir. Bkz. README ->
  /// "İçerik ve kaynaklar hakkında dürüst not".
  final String? sourceNote;

  /// Kullanıcının sonradan eklediği maddeler true olamaz; sadece
  /// seed_default_items() ile gelenler true'dur. Silme/düzenleme
  /// kısıtlaması için kullanılmaz — sadece detay ekranında
  /// "hazır liste maddesi" rozetini göstermek içindir.
  final bool isPreset;

  const BagItem({
    this.id,
    required this.name,
    required this.category,
    this.quantity = 1,
    this.note = '',
    this.isChecked = false,
    this.whyNeeded,
    this.sourceNote,
    this.isPreset = false,
  });

  BagItem copyWith({
    int? id,
    String? name,
    BagCategory? category,
    int? quantity,
    String? note,
    bool? isChecked,
    String? whyNeeded,
    String? sourceNote,
    bool? isPreset,
  }) {
    return BagItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
      isChecked: isChecked ?? this.isChecked,
      whyNeeded: whyNeeded ?? this.whyNeeded,
      sourceNote: sourceNote ?? this.sourceNote,
      isPreset: isPreset ?? this.isPreset,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category.dbValue,
      'quantity': quantity,
      'note': note,
      'is_checked': isChecked ? 1 : 0,
      'why_needed': whyNeeded,
      'source_note': sourceNote,
      'is_preset': isPreset ? 1 : 0,
    };
  }

  factory BagItem.fromMap(Map<String, Object?> map) {
    return BagItem(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: BagCategoryX.fromDbValue(map['category'] as String),
      quantity: map['quantity'] as int? ?? 1,
      note: map['note'] as String? ?? '',
      isChecked: (map['is_checked'] as int? ?? 0) == 1,
      whyNeeded: map['why_needed'] as String?,
      sourceNote: map['source_note'] as String?,
      isPreset: (map['is_preset'] as int? ?? 0) == 1,
    );
  }
}
