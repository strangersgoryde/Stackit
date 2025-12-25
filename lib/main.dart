import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/stack_the_snack_game.dart';
import 'ui/game_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GameModeWrapper(),
    );
  }
}

/// Wrapper widget that handles the game
class GameModeWrapper extends StatefulWidget {
  const GameModeWrapper({super.key});

  @override
  State<GameModeWrapper> createState() => _GameModeWrapperState();
}

class _GameModeWrapperState extends State<GameModeWrapper> {
  /// Game instance (created lazily)
  StackTheSnackGame? _stackGame;
  
  @override
  Widget build(BuildContext context) {
    return _buildStackTheSnackGame();
  }
  
  Widget _buildStackTheSnackGame() {
    // Create game instance if needed
    _stackGame ??= StackTheSnackGame();
    
    return GameWidget<StackTheSnackGame>(
      game: _stackGame!,
      overlayBuilderMap: {
        'Menu': (context, game) => GameUI.buildMenu(context, game),
        'HUD': (context, game) => GameUI.buildHUD(context, game),
        'GameOver': (context, game) => GameUI.buildGameOver(context, game),
        'LevelComplete': (context, game) => GameUI.buildLevelComplete(context, game),
        'Paused': (context, game) => GameUI.buildPaused(context, game),
        'RecipeBook': (context, game) => GameUI.buildRecipeBook(context, game),
        'Settings': (context, game) => GameUI.buildSettings(context, game),
      },
    );
  }
}
