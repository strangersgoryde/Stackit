import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart'; 
import '../game/config.dart';
import '../game/stack_the_snack_game.dart';
import '../game/level_manager.dart'; 
import '../game/audio_manager.dart';
import '../game/particle_helper.dart';
import 'falling_ingredient.dart';

class MovingBase extends PositionComponent with HasGameReference<StackTheSnackGame> {
  final String baseSpriteName;
  final bool isMainBase; // Whether this is the main stacking base or a visual copy
  final int baseIndex; // Index for spacing multiple bases
  late RectangleHitbox? landingZone;
  double currentHeight = 0;

  MovingBase({
    required this.baseSpriteName,
    this.isMainBase = true,
    this.baseIndex = 0,
    super.position,
  }) : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    final sprite = await game.loadSprite(baseSpriteName);
    
    final baseVisual = SpriteComponent(
      sprite: sprite,
      anchor: Anchor.bottomCenter,
      position: Vector2(0, 0),
    );
    // Scale down the base sprite
    baseVisual.size = sprite.srcSize * GameConfig.ingredientScale;
    
    size = baseVisual.size;
    currentHeight = size.y;
    
    add(baseVisual);
    
    // Only the main base has a landing zone for collision detection
    if (isMainBase) {
      landingZone = RectangleHitbox(
        position: Vector2(0, -size.y),
        size: size,
        anchor: Anchor.bottomCenter,
      );
      add(landingZone!);
    } else {
      landingZone = null;
    }
  }

  @override
  void update(double dt) {
    if (game.gameState != GameState.playing) return;
    
    super.update(dt);
    
    final baseSpeed = game.levelManager.currentSpeed;
    
    // Calculate wrapping boundaries
    const double leftBound = -GameConfig.worldWidth / 2;
    const double rightBound = GameConfig.worldWidth / 2;
    
    // Check if base is off-screen (not visible to player)
    final isOffScreen = position.x > rightBound + size.x / 2;
    
    // Move faster when off-screen to reduce waiting time
    final speed = isOffScreen ? baseSpeed * GameConfig.offScreenSpeedMultiplier : baseSpeed;

    // Move continuously from right to left
    position.x -= speed * dt;

    // When base exits left side, wrap around to right side
    if (position.x + size.x / 2 < leftBound - size.x) {
      position.x = rightBound + size.x * 2; // Start further right
    }
  }

  void stackItem(FallingIngredient ingredient) {
    if (game.gameState != GameState.playing) return;

    // Calculate Precision
    final offset = ingredient.position.x - position.x;
    final absOffset = offset.abs();

    // Use level-dependent thresholds (more forgiving in early levels)
    final toppleThreshold = game.levelManager.currentToppleThreshold;
    final perfectThreshold = game.levelManager.currentPerfectThreshold;

    if (absOffset > toppleThreshold) {
      // Item missed - but don't game over, just lose an attempt
      _handleMissedStack();
      return;
    }
    
    if (absOffset < perfectThreshold) {
      debugPrint("PERFECT!");
      AudioManager.playSfx('Perfect.ogg');
      final worldPos = position + Vector2(0, -currentHeight);
      game.world.add(ParticleHelper.createPerfectParticles(worldPos));
    } else {
      // Good landing but not perfect
      if (ingredient.spriteName.contains('patty') || ingredient.spriteName.contains('plate')) {
         AudioManager.playSfx('thud.ogg');
      } else {
         AudioManager.playSfx('squish.ogg');
      }
      
      // Wobble Effect for off-center landing
      add(
        RotateEffect.by(
          0.05 * (offset > 0 ? 1 : -1), 
          EffectController(
            duration: 0.1,
            reverseDuration: 0.1,
            curve: Curves.easeInOut,
          ),
        ),
      );
    }

    // Success Stack
    final relativePos = ingredient.position - position;
    
    final newItem = SpriteComponent(
      sprite: ingredient.sprite,
      size: ingredient.size,
      anchor: Anchor.bottomCenter,
      position: Vector2(relativePos.x, -currentHeight),
    );
    
    // Squash & Stretch
    newItem.add(
      ScaleEffect.to(
        Vector2(1.2, 0.8), 
        EffectController(
          duration: 0.1,
          reverseDuration: 0.1,
          curve: Curves.elasticOut,
        ),
      ),
    );
    
    add(newItem);
    
    // Add height with overlap so items appear naturally stacked (touching)
    // Use only a portion of the ingredient height to create tight stacking
    currentHeight += ingredient.size.y * GameConfig.stackOverlapFactor;
    
    // Update landing zone (only exists on main base)
    if (landingZone != null) {
      landingZone!.position = Vector2(0, -currentHeight);
      landingZone!.size = ingredient.size;
    }
    
    game.levelManager.onIngredientStacked();
  }
  
  /// Handle when an item lands but is too far off-center
  void _handleMissedStack() {
    AudioManager.playSfx('pop.ogg');
    
    // Add a small shake effect to indicate miss
    add(
      RotateEffect.by(
        0.1,
        EffectController(
          duration: 0.05,
          repeatCount: 4,
          reverseDuration: 0.05,
        ),
      ),
    );
    
    // This counts as a failed attempt (not instant game over)
    game.levelManager.onAttemptFailed();
  }
}
