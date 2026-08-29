// TASARIM SİSTEMİ — TEK KAYNAK NOKTASI
//
// Kural: Ekranlarda ve widget'larda ASLA doğrudan renk kodu (Color(0xFF...))
// veya sabit sayı (16.0, 8.0 vb.) yazılmaz. Her zaman bu dosyadaki
// sabitler kullanılır. Uygulama başka bir sisteme entegre edilecekse
// sadece bu dosya değiştirilir; ekran kodlarına dokunulmaz.

import 'package:flutter/material.dart';

/// Renk paleti. Kategori renkleri (Anne/Bebek/Evrak) ayrı tutulur çünkü
/// liste, detay ve özet ekranlarının hepsi bunları referans alır.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6C63A6);
  static const Color primaryDark = Color(0xFF4E4780);
  static const Color background = Color(0xFFFAF8FC);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF2B2640);
  static const Color textSecondary = Color(0xFF6F6B85);
  static const Color divider = Color(0xFFE7E3F0);

  static const Color success = Color(0xFF4CAF7D);
  static const Color warning = Color(0xFFE0A63A);

  // Kategori renkleri
  static const Color categoryAnne = Color(0xFFD87CA6);
  static const Color categoryBebek = Color(0xFF5FB4B0);
  static const Color categoryEvrak = Color(0xFFE6A15E);
}

/// Boşluk (spacing) ölçeği — 4px taban birim.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Köşe yarıçapları.
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 14;
  static const double lg = 22;
  static const double pill = 999;
}

/// Tipografi ölçeği. Ekranlar Theme.of(context).textTheme yerine
/// doğrudan bunu kullanır ki tema değişse bile tutarlı kalsın.
class AppTypography {
  AppTypography._();

  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}

/// MaterialApp'e verilecek tema; renk/tipografi sabitlerinden üretilir.
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      background: AppColors.background,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      titleTextStyle: AppTypography.title,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.divider),
      ),
    ),
    dividerColor: AppColors.divider,
    fontFamily: 'Roboto',
  );
}
