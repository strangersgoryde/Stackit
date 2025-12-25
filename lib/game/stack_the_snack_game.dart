import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'config.dart';
import 'level_manager.dart';
import 'audio_manager.dart'; 
import '../components/moving_base.dart';
import '../components/falling_ingredient.dart';
import '../components/kitchen_background.dart';
import '../components/pending_ingredient.dart'; 

class StackTheSnackGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  MovingBase? movingBase; // The main base where items stack
  List<MovingBase> visualBases = []; // Additional visual bases (no collision)
  PendingIngredient? pendingIngredient;
  late LevelManager levelManager;
  GameState _gameState = GameState.menu;

  late RectangleComponent _lightingOverlay;

  GameState get gameState => _gameState;
  
  set gameState(GameState newState) {
    _gameState = newState;
    _updateOverlays();
    
    if (_gameState == GameState.paused || _gameState == GameState.gameOver || _gameState == GameState.levelComplete || _gameState == GameState.menu) {
      pauseEngine();
      if (_gameState == GameState.menu) {
         AudioManager.playBgm('Menu.ogg');
      } else {
         AudioManager.stopBgm();
         if (_gameState == GameState.levelComplete) AudioManager.playSfx('Victory.ogg');
      }
    } else {
      resumeEngine();
      if (_gameState == GameState.playing) {
        AudioManager.playBgm('BGM.ogg');
      }
    }
  }

  StackTheSnackGame() : super(world: StackTheSnackWorld(), camera: CameraComponent.withFixedResolution(width: GameConfig.worldWidth, height: GameConfig.worldHeight));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    await AudioManager.init();
    
    camera.viewfinder.anchor = Anchor.center;
    
    // Fix: Add Background to camera.backdrop so it stays fixed to the screen
    camera.backdrop.add(KitchenBackground());
    
    levelManager = LevelManager();
    add(levelManager);
    
    _lightingOverlay = RectangleComponent(
      size: Vector2(GameConfig.worldWidth, GameConfig.worldHeight * 10), 
      paint: Paint()..color = Colors.black.withValues(alpha: 0.0),
      anchor: Anchor.center,
      position: Vector2(0, 0),
      priority: 99, 
    );
    world.add(_lightingOverlay);

    gameState = GameState.menu;
  }
  
  void _updateOverlays() {
    overlays.removeAll(['Menu', 'HUD', 'GameOver', 'LevelComplete', 'Paused']);
    
    switch (gameState) {
      case GameState.menu:
        overlays.add('Menu');
        break;
      case GameState.playing:
        overlays.add('HUD');
        break;
      case GameState.paused:
        overlays.add('Paused');
        overlays.add('HUD'); 
        break;
      case GameState.levelComplete:
        overlays.add('LevelComplete');
        overlays.add('HUD');
        break;
      case GameState.gameOver:
        overlays.add('GameOver');
        overlays.add('HUD');
        break;
    }
  }
  
  void resetGame() {
    world.children.whereType<FallingIngredient>().forEach((c) => c.removeFromParent());
    world.children.whereType<MovingBase>().forEach((c) => c.removeFromParent());
    world.children.whereType<ParticleSystemComponent>().forEach((c) => c.removeFromParent());
    world.children.whereType<PendingIngredient>().forEach((c) => c.removeFromParent());
    pendingIngredient = null;
    visualBases.clear();

    final recipe = levelManager.currentRecipe;
    final baseSpriteName = recipe.baseIngredient;
    final baseY = GameConfig.worldHeight / 2 - 100;
    
    // Calculate how many visual bases based on current level
    final numVisualBases = levelManager.getNumberOfBases();
    
    // Create main stacking base - starts at right side
    movingBase = MovingBase(
      baseSpriteName: baseSpriteName,
      isMainBase: true,
      baseIndex: 0,
      position: Vector2(GameConfig.worldWidth / 2, baseY),
    );
    world.add(movingBase!);
    
    // Create additional visual bases (no collision, just visual movement)
    for (int i = 1; i < numVisualBases; i++) {
      final visualBase = MovingBase(
        baseSpriteName: baseSpriteName,
        isMainBase: false,
        baseIndex: i,
        position: Vector2(
          GameConfig.worldWidth / 2 + (i * GameConfig.baseSpacing),
          baseY,
        ),
      );
      visualBases.add(visualBase);
      world.add(visualBase);
    }
    
    // Spawn pending ingredient at the top (stays centered)
    _spawnPendingIngredient();
    
    camera.viewfinder.position = Vector2(0, 0);
    
    _lightingOverlay.paint.color = Colors.black.withValues(alpha: 0.0);
  }
  
  void _spawnPendingIngredient() {
    // Remove existing pending ingredient
    pendingIngredient?.removeFromParent();
    pendingIngredient = null;
    
    // Get next ingredient to spawn at top
    final nextIngredient = levelManager.getNextIngredient();
    if (nextIngredient != null) {
      pendingIngredient = PendingIngredient(spriteName: nextIngredient);
      // Start position at top center
      pendingIngredient!.position = Vector2(0, -GameConfig.worldHeight / 2 + 120);
      world.add(pendingIngredient!);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (gameState != GameState.playing) return;

    if (movingBase != null) {
      final stackTopY = movingBase!.position.y - movingBase!.currentHeight;
      // Base offset is -250. Add dynamic adjustment from level manager (for endless mode)
      final targetCameraY = stackTopY - 250 - levelManager.cameraOffsetAdjustment;
      // Smoother camera tracking
      camera.viewfinder.position.y += (targetCameraY - camera.viewfinder.position.y) * 8 * dt;
      
      double height = 400 - stackTopY; 
      double darkness = (height / 5000).clamp(0.0, 0.4); 
      _lightingOverlay.paint.color = Colors.black.withValues(alpha: darkness);
      _lightingOverlay.position = camera.viewfinder.position;
    }
  }
  
  @override
  void onTapDown(TapDownEvent event) {
    if (gameState != GameState.playing) return;
    
    // Don't allow dropping if there's already a falling ingredient
    if (world.children.whereType<FallingIngredient>().isNotEmpty) {
      return; 
    }

    // Must have a pending ingredient to drop
    if (pendingIngredient == null) return;
    
    final nextIngredient = levelManager.getNextIngredient();
    if (nextIngredient == null) return; 
    
    // Get the current X position of the pending ingredient
    final dropX = pendingIngredient!.dropX;
    final dropY = pendingIngredient!.position.y;
    
    // Remove the pending ingredient
    pendingIngredient!.removeFromParent();
    pendingIngredient = null;
    
    // Spawn a falling ingredient at that position
    final ingredient = FallingIngredient(
      spriteName: nextIngredient, 
      position: Vector2(dropX, dropY),
    );
    
    world.add(ingredient);
  }
  
  /// Called by LevelManager when an ingredient is stacked
  void onIngredientStacked() {
    _spawnPendingIngredient();
  }
  
  /// Called by LevelManager when a life is lost
  void onLifeLost() {
    _spawnPendingIngredient();
  }

  @override
  Color backgroundColor() => const Color(0xFFFFF9F0);
}

class StackTheSnackWorld extends World {
  @override
  Future<void> onLoad() async {
    super.onLoad();
  }
}
