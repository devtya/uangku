import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palet warna semantik uangku, sadar-tema (light & dark) lewat ThemeExtension.
/// Akses di widget: `context.colors.primary`, dst.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color primary;
  final Color accent;
  final Color tint;
  final Color background;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color divider;
  final Color link;

  const AppPalette({
    required this.primary,
    required this.accent,
    required this.tint,
    required this.background,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.divider,
    required this.link,
  });

  static const light = AppPalette(
    primary: Color(0xFF012A63),
    accent: Color(0xFF11458C),
    tint: Color(0xFFE0EDFC),
    background: Color(0xFFEFF4F8),
    card: Color(0xFFFCFEFF),
    textPrimary: Color(0xFF141B24),
    textSecondary: Color(0xFF616A75),
    textMuted: Color(0xFF9299A2),
    border: Color(0xFFD8DFE6),
    divider: Color(0xFFE3E8EE),
    link: Color(0xFF427BC6),
  );

  static const dark = AppPalette(
    primary: Color(0xFF4C8DF6),
    accent: Color(0xFF3B6FB5),
    tint: Color(0xFF16233A),
    background: Color(0xFF0E1116),
    card: Color(0xFF171C22),
    textPrimary: Color(0xFFE7ECF2),
    textSecondary: Color(0xFF9BA6B2),
    textMuted: Color(0xFF6B7480),
    border: Color(0xFF2A313A),
    divider: Color(0xFF232A32),
    link: Color(0xFF6FA3E0),
  );

  @override
  AppPalette copyWith({
    Color? primary,
    Color? accent,
    Color? tint,
    Color? background,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? divider,
    Color? link,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      tint: tint ?? this.tint,
      background: background ?? this.background,
      card: card ?? this.card,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      link: link ?? this.link,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      tint: Color.lerp(tint, other.tint, t)!,
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      link: Color.lerp(link, other.link, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppPalette get colors => Theme.of(this).extension<AppPalette>()!;
}

class AppSpacing {
  const AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 28;
  static const double pageH = 20;
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(AppPalette.light, Brightness.light);
  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: p.primary,
      brightness: brightness,
    ).copyWith(
      primary: p.primary,
      surface: p.card,
      onSurface: p.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      extensions: [p],
      // Poppins ke seluruh teks; TextStyle eksplisit mewarisi via merge.
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: GoogleFonts.poppinsTextTheme(
        TextTheme(
          headlineSmall: TextStyle(
              fontWeight: FontWeight.w700, color: p.textPrimary),
          titleLarge:
              TextStyle(fontWeight: FontWeight.w700, color: p.textPrimary),
          titleMedium:
              TextStyle(fontWeight: FontWeight.w700, color: p.textPrimary),
          bodyMedium: TextStyle(color: p.textSecondary),
          titleSmall: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: p.textPrimary),
          bodySmall: TextStyle(fontSize: 12, color: p.textSecondary),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        foregroundColor: p.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: p.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: p.divider),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: p.primary, width: 1.5),
        ),
        labelStyle: TextStyle(fontSize: 13, color: p.textSecondary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.textSecondary,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: p.primary,
        foregroundColor: Colors.white,
        elevation: 8,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: p.card,
        selectedItemColor: p.primary,
        unselectedItemColor: p.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
