/// Doğum çantası listesindeki üç sabit kategori.
enum BagCategory { anne, bebek, evrak }

extension BagCategoryX on BagCategory {
  String get label {
    switch (this) {
      case BagCategory.anne:
        return 'Anne';
      case BagCategory.bebek:
        return 'Bebek';
      case BagCategory.evrak:
        return 'Evraklar';
    }
  }

  /// Veritabanında saklanan metin karşılığı (enum sırası değişse bile
  /// eski kayıtların bozulmaması için index yerine isim kullanılır).
  String get dbValue => name;

  static BagCategory fromDbValue(String value) {
    return BagCategory.values.firstWhere(
      (c) => c.name == value,
      orElse: () => BagCategory.anne,
    );
  }
}
