import 'package:flutter/material.dart';

/// Design Language for Stack the Snack
/// "Playful Pop" aesthetic: high contrast, rounded edges, warm food-centric palette
class GameTheme {
  // Color Palette (Warm Analogous with Cool Action)
  static const Color primary = Color(0xFFFF6B6B);      // Main buttons, logos
  static const Color secondary = Color(0xFFFFD93D);    // Stars, high scores, combos
  static const Color success = Color(0xFF6BCB77);      // Level complete, order success
  static const Color background = Color(0xFFFFF9F0);   // Soft cream background
  static const Color textDark = Color(0xFF2D3436);     // Main body text
  static const Color shadow = Color(0xFF636E72);       // Subtle shadows
  static const Color danger = Color(0xFFE74C3C);       // Game over, warnings
  
  // Gradient for timer bar
  static const LinearGradient timerGradient = LinearGradient(
    colors: [success, secondary, primary],
    stops: [0.0, 0.5, 1.0],
  );
  
  // Font families
  static const String displayFont = 'TitanOne';
  static const String bodyFont = 'Quicksand';
  
  // Text Styles
  static TextStyle get mainScore => const TextStyle(
    fontFamily: displayFont,
    fontSize: 48,
    color: primary,
    shadows: [
      Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4),
    ],
  );
  
  static TextStyle get heading => const TextStyle(
    fontFamily: displayFont,
    fontSize: 32,
    color: textDark,
    shadows: [
      Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 2),
    ],
  );
  
  static TextStyle get subheading => const TextStyle(
    fontFamily: displayFont,
    fontSize: 24,
    color: textDark,
  );
  
  static TextStyle get buttonText => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static TextStyle get bodyText => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: shadow,
  );
  
  static TextStyle get levelName => const TextStyle(
    fontFamily: bodyFont,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textDark,
  );
  
  static TextStyle get scoreText => const TextStyle(
    fontFamily: displayFont,
    fontSize: 28,
    color: success,  // Green for good readability
    // No shadow for cleaner appearance
  );
  
  // Button decoration - Capsule shaped with depth effect
  static BoxDecoration primaryButtonDecoration = BoxDecoration(
    color: primary,
    borderRadius: BorderRadius.circular(30),
    boxShadow: const [
      BoxShadow(
        color: Color(0xFFD95555),
        offset: Offset(0, 4),
        blurRadius: 0,
      ),
    ],
  );
  
  static BoxDecoration secondaryButtonDecoration = BoxDecoration(
    color: secondary,
    borderRadius: BorderRadius.circular(30),
    boxShadow: const [
      BoxShadow(
        color: Color(0xFFD4B22F),
        offset: Offset(0, 4),
        blurRadius: 0,
      ),
    ],
  );
  
  static BoxDecoration successButtonDecoration = BoxDecoration(
    color: success,
    borderRadius: BorderRadius.circular(30),
    boxShadow: const [
      BoxShadow(
        color: Color(0xFF56A863),
        offset: Offset(0, 4),
        blurRadius: 0,
      ),
    ],
  );
  
  // Card decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0, 8),
        blurRadius: 24,
      ),
    ],
  );
  
  // Overlay decoration with gradient
  static BoxDecoration overlayDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withValues(alpha: 0.3),
        Colors.black.withValues(alpha: 0.6),
      ],
    ),
  );
}

