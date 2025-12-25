import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'recipe.dart';
import 'config.dart';
import 'stack_the_snack_game.dart';
import 'audio_manager.dart'; // Import Audio

enum GameState {
  menu,
  playing,
  paused, 
  levelComplete,
  gameOver,
}

class LevelManager extends Component with HasGameReference<StackTheSnackGame> {
  int _currentLevelIndex = 0;
  late Recipe _currentRecipe;
  int _currentStep = 0;
  
  double _currentTimer = 20.0;
  bool _hasPlayedWarning = false;
  int _attemptsRemaining = 5; // Attempts for current item
  
  ValueNotifier<int> scoreNotifier = ValueNotifier(0);
  ValueNotifier<int> attemptsNotifier = ValueNotifier(5); // Attempts for current item
  ValueNotifier<String> levelNameNotifier = ValueNotifier("");
  ValueNotifier<int> levelNumberNotifier = ValueNotifier(1); // Current level number (1-based)
  ValueNotifier<double> timerNotifier = ValueNotifier(1.0);
  ValueNotifier<int> highScoreNotifier = ValueNotifier(0);
  ValueNotifier<int> endlessHighScoreNotifier = ValueNotifier(0);
  ValueNotifier<int> maxLevelNotifier = ValueNotifier(0); // Max level unlocked (0-based index)
  int _maxLevelReached = 0;
  bool isEndless = false;

  Recipe get currentRecipe => _currentRecipe;
  int get currentStep => _currentStep;
  int get currentLevelIndex => _currentLevelIndex;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadPersistence();
    _loadLevel(0);
  }

  Future<void> _loadPersistence() async {
    final prefs = await SharedPreferences.getInstance();
    highScoreNotifier.value = prefs.getInt('highScore') ?? 0;
    endlessHighScoreNotifier.value = prefs.getInt('highScoreEndless') ?? 0;
    _maxLevelReached = prefs.getInt('maxLevelReached') ?? 0;
    maxLevelNotifier.value = _maxLevelReached;
  }
  
  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (isEndless) {
      if (scoreNotifier.value > endlessHighScoreNotifier.value) {
        endlessHighScoreNotifier.value = scoreNotifier.value;
        await prefs.setInt('highScoreEndless', endlessHighScoreNotifier.value);
      }
    } else {
      if (scoreNotifier.value > highScoreNotifier.value) {
        highScoreNotifier.value = scoreNotifier.value;
        await prefs.setInt('highScore', highScoreNotifier.value);
      }
    }
  }

  Future<void> _saveUnlockedLevel() async {
    if (_currentLevelIndex > _maxLevelReached) {
      _maxLevelReached = _currentLevelIndex;
      maxLevelNotifier.value = _maxLevelReached;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('maxLevelReached', _maxLevelReached);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (game.gameState == GameState.playing) {
      _currentTimer -= dt;
      if (_currentTimer <= 0) {
        _currentTimer = 0;
        _onTimeOut();
      } else if (_currentTimer <= 3.0 && !_hasPlayedWarning) {
        _hasPlayedWarning = true;
        AudioManager.playSfx('Warning.ogg');
      }
      timerNotifier.value = _currentTimer / currentTimerDuration;
    }
  }

  void _loadLevel(int index) {
    if (index >= RecipeBook.recipes.length) {
      index = 0; 
    }
    _currentLevelIndex = index;
    _currentRecipe = RecipeBook.recipes[index];
    _currentStep = 0;
    levelNameNotifier.value = _currentRecipe.name;
    levelNumberNotifier.value = index + 1; // 1-based level number
    _resetTimer();
  }
  
  void _resetTimer() {
    _currentTimer = currentTimerDuration;
    timerNotifier.value = 1.0;
    _hasPlayedWarning = false;
  }
  
  void _onTimeOut() {
    // Timeout counts as a failed attempt, not instant game over
    onTimeoutAttempt();
  }

  void startGame() {
    isEndless = false;
    _loadLevel(0);
    _resetAttempts();
    scoreNotifier.value = 0;
    game.gameState = GameState.playing;
    game.resetGame();
  }
  
  void startEndlessGame() {
    isEndless = true;
    _currentLevelIndex = -1; // Special index for endless
    
    // Create a dummy recipe for endless mode init
    _currentRecipe = const Recipe(
      levelId: 999,
      category: SnackCategory.burger,
      name: "Endless Tower",
      ingredients: ['burger_bun_bottom.png'], // Just the base
    );
    
    _currentStep = 0;
    levelNameNotifier.value = "Endless Mode";
    levelNumberNotifier.value = 1;
    
    _resetTimer();
    _resetAttempts();
    scoreNotifier.value = 0;
    game.gameState = GameState.playing;
    game.resetGame();
  }
  
  /// Start game at a specific level (for level select)
  void startGameAtLevel(int levelIndex) {
    isEndless = false;
    if (levelIndex < 0 || levelIndex >= RecipeBook.recipes.length) {
      levelIndex = 0;
    }
    _loadLevel(levelIndex);
    _resetAttempts();
    scoreNotifier.value = 0;
    game.gameState = GameState.playing;
    game.resetGame();
  }
  
  /// Reset attempts for current item based on level difficulty
  void _resetAttempts() {
    _attemptsRemaining = attemptsPerItem;
    attemptsNotifier.value = _attemptsRemaining;
  }
  
  void pauseGame() {
    if (game.gameState == GameState.playing) {
      game.gameState = GameState.paused;
    }
  }
  
  void resumeGame() {
    if (game.gameState == GameState.paused) {
      game.gameState = GameState.playing;
    }
  }

  String? getNextIngredient() {
    if (isEndless) {
       // Random ingredients for endless mode
       final ingredients = [
         'burger_patty.png', 'burger_cheese.png', 'burger_lettuce.png', 'burger_tomato.png', 
         'burger_bacon.png', 'burger_onion_ring.png',
         'breakfast_pancakes.png', 'breakfast_waffle.png', 'breakfast_egg.png', 
         'breakfast_sausage.png', 'breakfast_toast.png',
         'donut_glazed.png', 'donut_chocolate.png', 'donut_pink.png',
         'sundae_vanilla.png', 'sundae_strawberry.png', 'sundae_mint.png',
         'cake_large.png', 'cake_medium.png', 'cake_small.png'
       ];
       return ingredients[Random().nextInt(ingredients.length)];
    }
  
    final nextIndex = _currentStep + 1;
    if (nextIndex < _currentRecipe.ingredients.length) {
      return _currentRecipe.ingredients[nextIndex];
    }
    return null;
  }

  void onIngredientStacked() {
    _currentStep++;
    scoreNotifier.value += 10;
    
    if (isEndless) {
      if (scoreNotifier.value > endlessHighScoreNotifier.value) {
        _saveHighScore();
      }
      // Speed up slightly every 5 items in endless mode
      if (_currentStep % 5 == 0) {
        // trigger any visual effect?
      }
    } else {
      if (scoreNotifier.value > highScoreNotifier.value) {
        _saveHighScore();
      }
    }
    
    _resetTimer();
    _resetAttempts(); // Reset attempts for the next item
    
    // Update ghost indicator for next ingredient
    game.onIngredientStacked();
    
    if (!isEndless && _currentStep >= _currentRecipe.ingredients.length - 1) {
      _completeLevel();
    }
  }
  
  void _completeLevel() {
    game.gameState = GameState.levelComplete;
    _saveUnlockedLevel();
    // Don't auto-advance - wait for player to tap "Next Level" button
  }
  
  void nextLevel() {
    _loadLevel(_currentLevelIndex + 1);
    game.resetGame();
    game.gameState = GameState.playing;
  }

  /// Called when player misses a stack attempt
  void onAttemptFailed() {
    _attemptsRemaining--;
    attemptsNotifier.value = _attemptsRemaining;
    
    if (_attemptsRemaining <= 0) {
      // No more attempts for this item - game over
      game.gameState = GameState.gameOver;
      AudioManager.playSfx('fail.ogg');
      _saveHighScore();
    } else {
      // Still have attempts - try again
      _resetTimer();
      game.onLifeLost(); // Respawn the ingredient
    }
  }
  
  /// Called when timer runs out (also counts as a failed attempt)
  void onTimeoutAttempt() {
    onAttemptFailed();
  }

  /// Returns the base movement speed based on current level difficulty tier
  double get currentSpeed {
    if (isEndless) {
      // Endless mode speed scaling
      // Start at medium speed (150) and increase by 5 every 2 steps
      return (GameConfig.mediumBaseSpeed + (_currentStep / 2) * 5.0).clamp(100.0, 500.0);
    }
    
    double baseSpeed;
    int tierStartLevel;
    
    // Difficulty tiers based on level (0-indexed)
    if (_currentLevelIndex < 3) {
      // Levels 1-3: Easy/Learning levels
      baseSpeed = GameConfig.easyBaseSpeed;
      tierStartLevel = 0;
    } else if (_currentLevelIndex < 7) {
      // Levels 4-7: Medium difficulty
      baseSpeed = GameConfig.mediumBaseSpeed;
      tierStartLevel = 3;
    } else if (_currentLevelIndex < 11) {
      // Levels 8-11: Hard difficulty  
      baseSpeed = GameConfig.hardBaseSpeed;
      tierStartLevel = 7;
    } else if (_currentLevelIndex < 14) {
      // Levels 12-14: Expert difficulty
      baseSpeed = GameConfig.expertBaseSpeed;
      tierStartLevel = 11;
    } else {
      // Levels 15-17: Master difficulty
      baseSpeed = GameConfig.masterBaseSpeed;
      tierStartLevel = 14;
    }
    
    // Add speed increment for each level within the tier
    final levelsIntoTier = _currentLevelIndex - tierStartLevel;
    baseSpeed += levelsIntoTier * GameConfig.speedIncrementPerLevel;
    
    // Additional slight speed increase as items are stacked within a level
    baseSpeed += (_currentStep ~/ 2) * 10.0;
    
    return baseSpeed;
  }
  
  /// Returns the number of bases to display based on current level
  /// Levels 1-3: 1 base (learning)
  /// Levels 4-7: 2 bases
  /// Levels 8+: 3 bases
  int getNumberOfBases() {
    if (isEndless) return 2; // Always 2 bases for endless for now
    
    if (_currentLevelIndex < 3) {
      return 1; // Learning levels - just one base
    } else if (_currentLevelIndex < 7) {
      return 2; // Medium levels - two bases
    } else {
      return 3; // Hard levels - three bases
    }
  }
  
  /// Returns the timer duration based on current level
  /// Longer timer in early levels = easier
  double get currentTimerDuration {
    if (isEndless) {
      // Endless mode timer scaling
      // Start at 15s, decrease by 0.5s every 10 steps, min 4s
      return (15.0 - (_currentStep / 10) * 0.5).clamp(4.0, 20.0);
    }

    if (_currentLevelIndex < 3) {
      return GameConfig.easyTimerDuration;    // 20 seconds
    } else if (_currentLevelIndex < 7) {
      return GameConfig.mediumTimerDuration;  // 14 seconds
    } else if (_currentLevelIndex < 11) {
      return GameConfig.hardTimerDuration;    // 10 seconds
    } else if (_currentLevelIndex < 14) {
      return GameConfig.expertTimerDuration;  // 7 seconds
    } else {
      return GameConfig.masterTimerDuration;  // 5 seconds
    }
  }
  
  /// Returns the drop gravity based on current level
  /// Faster gravity (higher value) in early levels = easier to aim
  double get currentDropGravity {
    if (isEndless) {
      // Gravity gets slightly harder (slower drop) over time? 
      // Actually faster drop is easier, so let's keep it constant or make it harder (slower)
      // Let's start fast (easy) and get slower (harder)
      return (GameConfig.mediumDropGravity - (_currentStep * 5.0)).clamp(400.0, 1000.0);
    }

    if (_currentLevelIndex < 3) {
      return GameConfig.easyDropGravity;      // 1200 - fast drop
    } else if (_currentLevelIndex < 7) {
      return GameConfig.mediumDropGravity;    // 950
    } else if (_currentLevelIndex < 11) {
      return GameConfig.hardDropGravity;      // 750
    } else if (_currentLevelIndex < 14) {
      return GameConfig.expertDropGravity;    // 550
    } else {
      return GameConfig.masterDropGravity;    // 450 - very slow drop
    }
  }
  
  /// Returns the topple threshold based on current level
  /// Higher value = more forgiving (can be more off-center)
  double get currentToppleThreshold {
    if (isEndless) {
      // Get stricter over time
      return (GameConfig.mediumToppleThreshold - (_currentStep * 0.5)).clamp(40.0, 100.0);
    }

    if (_currentLevelIndex < 3) {
      return GameConfig.easyToppleThreshold;    // 120 pixels - very forgiving
    } else if (_currentLevelIndex < 7) {
      return GameConfig.mediumToppleThreshold;  // 95 pixels
    } else if (_currentLevelIndex < 11) {
      return GameConfig.hardToppleThreshold;    // 75 pixels
    } else if (_currentLevelIndex < 14) {
      return GameConfig.expertToppleThreshold;  // 55 pixels
    } else {
      return GameConfig.masterToppleThreshold;  // 40 pixels - very strict
    }
  }
  
  /// Returns the perfect threshold based on current level
  double get currentPerfectThreshold {
    if (isEndless) {
       return (GameConfig.mediumPerfectThreshold - (_currentStep * 0.2)).clamp(10.0, 35.0);
    }

    if (_currentLevelIndex < 3) {
      return GameConfig.easyPerfectThreshold;   // 40 pixels
    } else if (_currentLevelIndex < 7) {
      return GameConfig.mediumPerfectThreshold; // 32 pixels
    } else if (_currentLevelIndex < 11) {
      return GameConfig.hardPerfectThreshold;   // 24 pixels
    } else if (_currentLevelIndex < 14) {
      return GameConfig.expertPerfectThreshold; // 18 pixels
    } else {
      return GameConfig.masterPerfectThreshold; // 12 pixels - very precise
    }
  }
  
  /// Returns attempts per item based on current level
  int get attemptsPerItem {
    if (isEndless) return 2; // Always 2 lives per item in endless

    if (_currentLevelIndex < 3) {
      return GameConfig.easyAttemptsPerItem;    // 3 attempts
    } else if (_currentLevelIndex < 7) {
      return GameConfig.mediumAttemptsPerItem;  // 2 attempts
    } else if (_currentLevelIndex < 11) {
      return GameConfig.hardAttemptsPerItem;    // 2 attempts
    } else if (_currentLevelIndex < 14) {
      return GameConfig.expertAttemptsPerItem;  // 1 attempt
    } else {
      return GameConfig.masterAttemptsPerItem;  // 1 attempt
    }
  }

  /// Returns the ingredient scale. 
  /// In endless mode, this reduces as the stack gets higher.
  double get currentIngredientScale {
    if (isEndless) {
      // Start at default 0.5 and reduce by 0.005 every step
      // Min scale 0.25 to ensure it's still visible/playable
      return (GameConfig.ingredientScale - (_currentStep * 0.005)).clamp(0.25, GameConfig.ingredientScale);
    }
    return GameConfig.ingredientScale;
  }
  
  /// Returns the additional camera offset.
  /// In endless mode, we push the camera up slightly more as the stack grows
  /// to ensure plenty of space between stack and drop point.
  double get cameraOffsetAdjustment {
    if (isEndless) {
      // Increase offset by up to 100 pixels over time
      return (_currentStep * 2.0).clamp(0.0, 100.0);
    }
    return 0.0;
  }
}
