import 'package:flame/components.dart';
import '../game/config.dart';
import '../game/stack_the_snack_game.dart';
import '../game/level_manager.dart';

/// The ingredient that hovers at the top of the screen.
/// It stays stationary at the center - only the base moves.
/// When the player taps, this drops straight down.
class PendingIngredient extends SpriteComponent with HasGameReference<StackTheSnackGame> {
  final String spriteName;
  
  PendingIngredient({
    required this.spriteName,
  }) : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    sprite = await game.loadSprite(spriteName);
    if (sprite != null) {
      // Scale down the size based on current level/endless progress
      size = sprite!.srcSize * game.levelManager.currentIngredientScale;
    }
    
    // Position at center horizontally
    position.x = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (game.gameState != GameState.playing) return;
    
    // Stay stationary at the center - only update Y position to follow camera
    position.x = 0; // Always centered
    
    // Stay at the top of the visible area
    final visibleTop = game.camera.viewfinder.position.y - GameConfig.worldHeight / 2;
    position.y = visibleTop + 120; // Fixed position near top
  }
  
  /// Returns the current X position for spawning a falling ingredient
  double get dropX => position.x;
}

