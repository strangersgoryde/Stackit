import 'package:flutter/material.dart';
import '../game/stack_the_snack_game.dart';
import '../game/level_manager.dart';
import '../game/recipe.dart';
import 'theme.dart';

class GameUI {
  static Widget buildMenu(BuildContext context, StackTheSnackGame game) {
    return Container(
      // Full page background with the new kitchen image
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/menubg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Main content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 140,
                          errorBuilder: (ctx, err, stack) => Column(
                            children: [
                              const Text("🍔", style: TextStyle(fontSize: 56)),
                              Text(
                                "Stack the\nSnack",
                                textAlign: TextAlign.center,
                                style: GameTheme.heading.copyWith(
                                  fontSize: 36,
                                  color: GameTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // High Score Card - "Tallest Stack"
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.95),
                              const Color(0xFFFFF5E6).withValues(alpha: 0.95),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: GameTheme.secondary.withValues(alpha: 0.5),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: GameTheme.secondary.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.emoji_events_rounded,
                                  color: GameTheme.secondary,
                                  size: 32,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "TALLEST STACK",
                                  style: GameTheme.bodyText.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                    color: GameTheme.shadow,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ValueListenableBuilder<int>(
                              valueListenable:
                                  game.levelManager.highScoreNotifier,
                              builder: (ctx, highScore, _) => Text(
                                "$highScore",
                                style: GameTheme.mainScore.copyWith(
                                  fontSize: 56,
                                  color: GameTheme.primary,
                                  shadows: [
                                    Shadow(
                                      color: GameTheme.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      offset: const Offset(3, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Play Button - Large and prominent
                      _buildMenuButton(
                        onPressed: () => game.levelManager.startGame(),
                        label: "PLAY",
                        icon: Icons.play_arrow_rounded,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFF7B7B), Color(0xFFFF5252)],
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            const BoxShadow(
                              color: Color(0xFFD94444),
                              offset: Offset(0, 6),
                              blurRadius: 0,
                            ),
                            BoxShadow(
                              color: GameTheme.primary.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        isLarge: true,
                      ),
                      const SizedBox(height: 18),
                      
                      // Endless Mode Button
                      _buildMenuButton(
                        onPressed: () => game.levelManager.startEndlessGame(),
                        label: "ENDLESS MODE",
                        icon: Icons.all_inclusive_rounded,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)], // Blue
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            const BoxShadow(
                              color: Color(0xFF1E88E5),
                              offset: Offset(0, 5),
                              blurRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        textColor: Colors.white,
                        iconColor: Colors.white,
                      ),
                      const SizedBox(height: 18),

                      // Recipe Book Button
                      _buildMenuButton(
                        onPressed: () => game.overlays.add('RecipeBook'),
                        label: "RECIPE BOOK",
                        icon: Icons.menu_book_rounded,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFFE066), Color(0xFFFFD93D)],
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            const BoxShadow(
                              color: Color(0xFFD4B22F),
                              offset: Offset(0, 5),
                              blurRadius: 0,
                            ),
                            BoxShadow(
                              color: GameTheme.secondary.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        textColor: GameTheme.textDark,
                        iconColor: GameTheme.textDark,
                      ),
                      const SizedBox(height: 18),

                      // Settings Button
                      _buildMenuButton(
                        onPressed: () => game.overlays.add('Settings'),
                        label: "SETTINGS",
                        icon: Icons.settings_rounded,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: GameTheme.shadow.withValues(alpha: 0.2),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        textColor: GameTheme.textDark,
                        iconColor: GameTheme.shadow,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMenuButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required BoxDecoration decoration,
    Color textColor = Colors.white,
    Color iconColor = Colors.white,
    bool isLarge = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Transform.scale(
        scale: 0.8 + (0.2 * value.clamp(0.0, 1.0)),
        child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLarge ? 56 : 40,
            vertical: isLarge ? 20 : 16,
          ),
          decoration: decoration,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: isLarge ? 36 : 28),
              const SizedBox(width: 12),
              Text(
                label,
                style: GameTheme.buttonText.copyWith(
                  fontSize: isLarge ? 26 : 20,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Recipe Book Overlay (Level Select)
  static Widget buildRecipeBook(BuildContext context, StackTheSnackGame game) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.5),
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: Container(
              margin: const EdgeInsets.all(20),
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9F0),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          GameTheme.secondary.withValues(alpha: 0.2),
                          GameTheme.primary.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.menu_book_rounded,
                          color: GameTheme.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Recipe Book",
                          style: GameTheme.heading.copyWith(fontSize: 28),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => game.overlays.remove('RecipeBook'),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: GameTheme.shadow,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Level Grid
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ValueListenableBuilder<int>(
                        valueListenable: game.levelManager.maxLevelNotifier,
                        builder: (context, maxLevel, _) => GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.4,
                              ),
                          itemCount: 17, // Show 17 levels
                          itemBuilder: (context, index) {
                            final isUnlocked = index <= maxLevel;
                            final recipe = RecipeBook.recipes[index];
                            return _buildLevelTile(
                              context,
                              game,
                              levelIndex: index,
                              recipe: recipe,
                              isUnlocked: isUnlocked,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildLevelTile(
    BuildContext context,
    StackTheSnackGame game, {
    required int levelIndex,
    required Recipe recipe,
    required bool isUnlocked,
  }) {
    // Category emojis
    final categoryEmoji = switch (recipe.category) {
      SnackCategory.burger => "🍔",
      SnackCategory.breakfast => "🥞",
      SnackCategory.donut => "🍩",
      SnackCategory.sundae => "🍨",
      SnackCategory.cake => "🎂",
    };

    // Category colors
    final categoryColor = switch (recipe.category) {
      SnackCategory.burger => const Color(0xFFFF6B6B),
      SnackCategory.breakfast => const Color(0xFFFFB347),
      SnackCategory.donut => const Color(0xFFFF69B4),
      SnackCategory.sundae => const Color(0xFF87CEEB),
      SnackCategory.cake => const Color(0xFFDDA0DD),
    };

    return GestureDetector(
      onTap: isUnlocked
          ? () {
              game.overlays.remove('RecipeBook');
              game.levelManager.startGameAtLevel(levelIndex);
            }
          : null,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 300 + (levelIndex * 50)),
        curve: Curves.easeOutBack,
        builder: (context, value, child) => Transform.scale(
          scale: 0.5 + (0.5 * value.clamp(0.0, 1.0)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: isUnlocked
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      categoryColor.withValues(alpha: 0.9),
                      categoryColor.withValues(alpha: 0.7),
                    ],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey.shade400, Colors.grey.shade500],
                  ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isUnlocked
                    ? categoryColor.withValues(alpha: 0.4)
                    : Colors.grey.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${levelIndex + 1}",
                            style: GameTheme.buttonText.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          categoryEmoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style: GameTheme.bodyText.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${recipe.ingredients.length} items",
                          style: GameTheme.bodyText.copyWith(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Lock overlay
              if (!isUnlocked)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Settings Overlay
  static Widget buildSettings(BuildContext context, StackTheSnackGame game) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.5),
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) =>
                Transform.scale(scale: scale, child: child),
            child: Container(
              margin: const EdgeInsets.all(24),
              constraints: const BoxConstraints(maxWidth: 360),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9F0),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          GameTheme.shadow.withValues(alpha: 0.1),
                          GameTheme.primary.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.settings_rounded,
                          color: GameTheme.shadow,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Settings",
                          style: GameTheme.heading.copyWith(fontSize: 28),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => game.overlays.remove('Settings'),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: GameTheme.shadow,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Settings options
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          icon: Icons.info_outline_rounded,
                          title: "About",
                          subtitle: "Learn about Stack the Snack",
                          onTap: () => _showAboutDialog(context, game),
                          color: GameTheme.primary,
                        ),
                        const SizedBox(height: 12),
                        _buildSettingsItem(
                          icon: Icons.school_rounded,
                          title: "How to Play",
                          subtitle: "Game guides and tips",
                          onTap: () {
                            game.overlays.remove('Settings');
                            _showHowToPlay(context);
                          },
                          color: GameTheme.success,
                        ),
                        const SizedBox(height: 12),
                        _buildSettingsItem(
                          icon: Icons.privacy_tip_outlined,
                          title: "Privacy Policy",
                          subtitle: "How we handle your data",
                          onTap: () => _showPrivacyPolicy(context, game),
                          color: GameTheme.secondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GameTheme.bodyText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GameTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GameTheme.bodyText.copyWith(
                      fontSize: 12,
                      color: GameTheme.shadow,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: GameTheme.shadow.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  static void _showAboutDialog(BuildContext context, StackTheSnackGame game) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(28),
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 100,
                errorBuilder: (ctx, err, stack) =>
                    const Text("🍔", style: TextStyle(fontSize: 64)),
              ),
              const SizedBox(height: 16),
              Text(
                "Stack the Snack",
                style: GameTheme.heading.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                "Version 1.0.0",
                style: GameTheme.bodyText.copyWith(
                  fontSize: 14,
                  color: GameTheme.shadow,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "A precision-timing 2D game where you build delicious food stacks! Test your reflexes and stack ingredients perfectly to complete recipes.",
                textAlign: TextAlign.center,
                style: GameTheme.bodyText.copyWith(
                  fontSize: 14,
                  color: GameTheme.textDark,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  decoration: GameTheme.primaryButtonDecoration,
                  child: Text("CLOSE", style: GameTheme.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showPrivacyPolicy(BuildContext context, StackTheSnackGame game) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.privacy_tip_outlined,
                    color: GameTheme.secondary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Privacy Policy",
                    style: GameTheme.heading.copyWith(fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    "Stack the Snack Privacy Policy\n\n"
                    "Last updated: December 2025\n\n"
                    "1. Data Collection\n"
                    "We collect minimal data to provide you with the best gaming experience. Your high scores and game progress are stored locally on your device.\n\n"
                    "2. Local Storage\n"
                    "Game progress and settings are saved locally using your device's storage. This data never leaves your device.\n\n"
                    "3. No Personal Information\n"
                    "We do not collect, store, or share any personal information such as names, email addresses, or contact details.\n\n"
                    "4. No Third-Party Tracking\n"
                    "Stack the Snack does not use any third-party analytics or tracking services.\n\n"
                    "5. Children's Privacy\n"
                    "Our game is suitable for all ages and does not collect any data from children.\n\n"
                    "6. Contact\n"
                    "If you have any questions about this privacy policy, please contact us through the app store listing.",
                    style: GameTheme.bodyText.copyWith(
                      fontSize: 13,
                      color: GameTheme.textDark,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  decoration: GameTheme.secondaryButtonDecoration,
                  child: Text(
                    "CLOSE",
                    style: GameTheme.buttonText.copyWith(
                      color: GameTheme.textDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildGameOver(BuildContext context, StackTheSnackGame game) {
    return Container(
      decoration: GameTheme.overlayDecoration,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          builder: (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
            decoration: GameTheme.cardDecoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Game Over Title
                Text(
                  "OOPS!",
                  style: GameTheme.heading.copyWith(
                    color: GameTheme.danger,
                    fontSize: 42,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Stack Collapsed!",
                  style: GameTheme.bodyText.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 24),
                // Score Display
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        GameTheme.primary.withValues(alpha: 0.1),
                        GameTheme.secondary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: game.levelManager.scoreNotifier,
                        builder: (ctx, score, _) => Text(
                          "$score",
                          style: GameTheme.mainScore.copyWith(fontSize: 56),
                        ),
                      ),
                      Text("POINTS", style: GameTheme.bodyText),
                      const SizedBox(height: 12),
                      if (game.levelManager.isEndless)
                        ValueListenableBuilder<int>(
                          valueListenable:
                              game.levelManager.endlessHighScoreNotifier,
                          builder: (ctx, highScore, _) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.all_inclusive_rounded,
                                color: GameTheme.secondary,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Best: $highScore",
                                style: GameTheme.bodyText.copyWith(
                                  color: GameTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ValueListenableBuilder<int>(
                          valueListenable: game.levelManager.highScoreNotifier,
                          builder: (ctx, highScore, _) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: GameTheme.secondary,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Best: $highScore",
                                style: GameTheme.bodyText.copyWith(
                                  color: GameTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Buttons
                _buildButton(
                  onPressed: () {
                     if (game.levelManager.isEndless) {
                       game.levelManager.startEndlessGame();
                     } else {
                       game.levelManager.startGame(); // This restarts level 1? Or current level? 
                       // Wait, standard startGame() loads level 0. 
                       // We should probably have a retry method in LevelManager or use startGameAtLevel
                       // For now, let's just use what was there but handle endless
                       // Actually the original code was: onPressed: () => game.levelManager.startGame(),
                       // Which always restarts from level 1.
                       // Ideally 'Try Again' should restart the *current* level.
                       // Let's fix that while we're here.
                       game.levelManager.startGameAtLevel(game.levelManager.currentLevelIndex);
                     }
                  },
                  label: "TRY AGAIN",
                  decoration: GameTheme.primaryButtonDecoration,
                  icon: Icons.refresh_rounded,
                ),
                const SizedBox(height: 12),
                _buildSmallButton(
                  onPressed: () => game.gameState = GameState.menu,
                  label: "Main Menu",
                  color: GameTheme.shadow,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildPaused(BuildContext context, StackTheSnackGame game) {
    return Container(
      decoration: GameTheme.overlayDecoration,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
          decoration: GameTheme.cardDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.pause_circle_filled,
                size: 64,
                color: GameTheme.secondary,
              ),
              const SizedBox(height: 16),
              Text("PAUSED", style: GameTheme.heading),
              const SizedBox(height: 32),
              _buildButton(
                onPressed: () => game.levelManager.resumeGame(),
                label: "RESUME",
                decoration: GameTheme.successButtonDecoration,
                icon: Icons.play_arrow_rounded,
              ),
              const SizedBox(height: 12),
              _buildSmallButton(
                onPressed: () => game.gameState = GameState.menu,
                label: "Quit to Menu",
                color: GameTheme.shadow,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildLevelComplete(
    BuildContext context,
    StackTheSnackGame game,
  ) {
    return Container(
      decoration: GameTheme.overlayDecoration,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, scale, child) =>
              Transform.scale(scale: scale, child: child),
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
            decoration: GameTheme.cardDecoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Stars animation
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (i) => TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400 + i * 200),
                      curve: Curves.bounceOut,
                      builder: (context, value, _) => Transform.scale(
                        scale: value,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.star_rounded,
                            size: 48,
                            color: GameTheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Level Complete Title
                Text(
                  "LEVEL COMPLETE!",
                  style: GameTheme.heading.copyWith(
                    color: GameTheme.success,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                // Level info
                ValueListenableBuilder<int>(
                  valueListenable: game.levelManager.levelNumberNotifier,
                  builder: (ctx, levelNum, _) => ValueListenableBuilder<String>(
                    valueListenable: game.levelManager.levelNameNotifier,
                    builder: (ctx, name, _) => Column(
                      children: [
                        Text(
                          "Level $levelNum",
                          style: GameTheme.bodyText.copyWith(
                            fontSize: 14,
                            color: GameTheme.shadow,
                          ),
                        ),
                        Text(
                          name,
                          style: GameTheme.levelName.copyWith(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Score earned this level
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        GameTheme.success.withValues(alpha: 0.15),
                        GameTheme.secondary.withValues(alpha: 0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: game.levelManager.scoreNotifier,
                    builder: (ctx, score, _) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: GameTheme.secondary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$score points",
                          style: GameTheme.scoreText.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                // Next Level Button
                _buildButton(
                  onPressed: () => game.levelManager.nextLevel(),
                  label: "NEXT LEVEL",
                  decoration: GameTheme.successButtonDecoration,
                  icon: Icons.arrow_forward_rounded,
                ),
                const SizedBox(height: 12),
                // Main Menu Button
                _buildSmallButton(
                  onPressed: () => game.gameState = GameState.menu,
                  label: "Main Menu",
                  color: GameTheme.shadow,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildHUD(BuildContext context, StackTheSnackGame game) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Level info and Pause
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  // Level name and Score
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85), // More transparent
                      borderRadius: BorderRadius.circular(20), // Softer corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05), // Softer shadow
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Level number and name
                    ValueListenableBuilder<int>(
                      valueListenable: game.levelManager.levelNumberNotifier,
                      builder: (ctx, levelNum, _) =>
                          ValueListenableBuilder<String>(
                            valueListenable:
                                game.levelManager.levelNameNotifier,
                            builder: (ctx, name, _) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!game.levelManager.isEndless)
                                  Text(
                                    "Level $levelNum",
                                    style: GameTheme.bodyText.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: GameTheme.primary,
                                    ),
                                  ),
                                Text(
                                  name,
                                  style: GameTheme.levelName.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
                      const SizedBox(height: 4),
                      ValueListenableBuilder<int>(
                        valueListenable: game.levelManager.scoreNotifier,
                        builder: (ctx, score, _) => Text(
                          "Score: $score",
                          style: GameTheme.scoreText.copyWith(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                  // Pause Button
                  GestureDetector(
                    onTap: () => game.levelManager.pauseGame(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.pause_rounded,
                        size: 28,
                        color: GameTheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Timer Bar and Attempts in a single row
            Row(
              children: [
                // Timer Bar (takes most of the space)
                Expanded(
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ValueListenableBuilder<double>(
                      valueListenable: game.levelManager.timerNotifier,
                      builder: (ctx, value, _) => FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: value < 0.3
                                  ? [GameTheme.danger, GameTheme.primary]
                                  : [GameTheme.success, GameTheme.secondary],
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                  // Attempts Remaining (compact, on the right)
                  ValueListenableBuilder<int>(
                    valueListenable: game.levelManager.attemptsNotifier,
                    builder: (ctx, attempts, _) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: attempts > 1
                              ? GameTheme.success
                              : GameTheme.danger,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$attempts",
                          style: GameTheme.bodyText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: attempts > 1
                                ? GameTheme.success
                                : GameTheme.danger,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable styled button
  static Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
    required BoxDecoration decoration,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        decoration: decoration,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 8),
            ],
            Text(label, style: GameTheme.buttonText),
          ],
        ),
      ),
    );
  }

  static Widget _buildSmallButton({
    required VoidCallback onPressed,
    required String label,
    required Color color,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: GameTheme.bodyText.copyWith(
          color: color,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  static void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "How to Play",
                style: GameTheme.heading.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 20),
              _buildHowToStep("1️⃣", "TAP anywhere to drop the ingredient"),
              _buildHowToStep("2️⃣", "Land it on the moving base below"),
              _buildHowToStep("3️⃣", "Perfect alignment = bonus points!"),
              _buildHowToStep(
                "4️⃣",
                "Complete the recipe before time runs out",
              ),
              _buildHowToStep(
                "💡",
                "Early levels give you more tries per item!",
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  decoration: GameTheme.successButtonDecoration,
                  child: Text("GOT IT!", style: GameTheme.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildHowToStep(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GameTheme.bodyText.copyWith(
                fontSize: 15,
                color: GameTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
