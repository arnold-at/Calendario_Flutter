import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Palette ───────────────────────────────────────────────
  static const Color background    = Color(0xFFF5F3EE); // warm off-white
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color surfaceMuted  = Color(0xFFEFEDE8); // warm light grey
  static const Color cardBorder    = Color(0xFFE2DFDA);

  static const Color textPrimary   = Color(0xFF1C1C1E); // near-black
  static const Color textSecondary = Color(0xFF6B6860); // warm grey
  static const Color textTertiary  = Color(0xFFABA89E); // muted

  static const Color accent        = Color(0xFFC19A55); // warm gold
  static const Color accentLight   = Color(0xFFF5E9CF); // gold tint bg
  static const Color accentDark    = Color(0xFF8C6B2F); // deep gold

  static const Color sageLight     = Color(0xFFE6EDE6); // sage tint
  static const Color sage          = Color(0xFF7A9B7A); // muted sage
  static const Color sageDark      = Color(0xFF4A6B4A);

  static const Color slateLight    = Color(0xFFE4E9EE);
  static const Color slate         = Color(0xFF7A8FA0);
  static const Color slateDark     = Color(0xFF3D5368);

  // ─── Event category colors ─────────────────────────────────
  static const Color catWork       = Color(0xFF5A7FA8); // calm blue
  static const Color catPersonal   = Color(0xFF7A9B7A); // sage
  static const Color catHealth     = Color(0xFFB07A5A); // warm terracotta
  static const Color catSocial     = Color(0xFFA07AB0); // dusty mauve
  static const Color catFocus      = Color(0xFFC19A55); // gold accent

  // ─── Theme ─────────────────────────────────────────────────
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        primary: accent,
        secondary: sage,
        surface: surface,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.cormorantTextTheme().copyWith(
        displayLarge: GoogleFonts.cormorant(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineLarge: GoogleFonts.cormorant(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        headlineMedium: GoogleFonts.cormorant(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.1,
        ),
        titleMedium: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textTertiary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}