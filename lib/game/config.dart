class GameConfig {
  // Base movement speeds per difficulty tier
  static const double easyBaseSpeed = 100.0;    // Levels 1-3 (learning levels)
  static const double mediumBaseSpeed = 150.0;  // Levels 4-7
  static const double hardBaseSpeed = 210.0;    // Levels 8-11
  static const double expertBaseSpeed = 280.0;  // Levels 12-14
  static const double masterBaseSpeed = 350.0;  // Levels 15-17 (master levels)
  
  // Speed increment per level within a tier
  static const double speedIncrementPerLevel = 18.0; // +18 speed per level
  
  // Drop gravity per difficulty tier (faster drop = easier to aim)
  static const double easyDropGravity = 1200.0;   // Levels 1-3: Fast drop (easy)
  static const double mediumDropGravity = 950.0;  // Levels 4-7: Medium drop
  static const double hardDropGravity = 750.0;    // Levels 8-11: Slower drop
  static const double expertDropGravity = 550.0;  // Levels 12-14: Slow drop
  static const double masterDropGravity = 450.0;  // Levels 15-17: Very slow (hard)
  
  // Timer durations per difficulty tier (more time = easier)
  static const double easyTimerDuration = 20.0;   // Levels 1-3: 20 seconds
  static const double mediumTimerDuration = 14.0; // Levels 4-7: 14 seconds
  static const double hardTimerDuration = 10.0;   // Levels 8-11: 10 seconds
  static const double expertTimerDuration = 7.0;  // Levels 12-14: 7 seconds
  static const double masterTimerDuration = 5.0;  // Levels 15-17: 5 seconds
  
  // Timing / Precision thresholds per difficulty tier
  // Perfect threshold - how close to center for "PERFECT" bonus
  static const double easyPerfectThreshold = 40.0;    // Levels 1-3: Very forgiving
  static const double mediumPerfectThreshold = 32.0;  // Levels 4-7
  static const double hardPerfectThreshold = 24.0;    // Levels 8-11
  static const double expertPerfectThreshold = 18.0;  // Levels 12-14
  static const double masterPerfectThreshold = 12.0;  // Levels 15-17: Very precise
  
  // Topple threshold - how far off-center before it counts as a miss
  // Higher = more forgiving (item can be more off-center and still stack)
  static const double easyToppleThreshold = 120.0;    // Levels 1-3: Very forgiving
  static const double mediumToppleThreshold = 95.0;   // Levels 4-7
  static const double hardToppleThreshold = 75.0;     // Levels 8-11
  static const double expertToppleThreshold = 55.0;   // Levels 12-14
  static const double masterToppleThreshold = 40.0;   // Levels 15-17: Very strict
  
  // Attempts per item (chances to stack each ingredient)
  static const int easyAttemptsPerItem = 3;     // Levels 1-3: 3 tries per item
  static const int mediumAttemptsPerItem = 2;   // Levels 4-7: 2 tries per item
  static const int hardAttemptsPerItem = 2;     // Levels 8-11: 2 tries per item
  static const int expertAttemptsPerItem = 1;   // Levels 12-14: 1 try only
  static const int masterAttemptsPerItem = 1;   // Levels 15-17: 1 try only

  // World dimensions
  static const double worldWidth = 600.0;
  static const double worldHeight = 1000.0;
  
  // Ingredient scaling (reduce size)
  static const double ingredientScale = 0.5;
  
  // Multiple bases configuration
  static const int maxVisualBases = 3; // Maximum number of visual bases on screen
  static const double baseSpacing = 300.0; // Horizontal spacing between bases
  
  // Off-screen speed multiplier - base moves faster when not visible
  // This reduces waiting time when base loops around
  static const double offScreenSpeedMultiplier = 4.0; // 4x faster when off-screen
  
  // Stack overlap factor - how much of each item's height is added to the stack
  // Lower value = tighter stacking (items overlap more, appear closer together)
  // 1.0 = no overlap (full height), 0.5 = 50% overlap, 0.7 = 30% overlap
  static const double stackOverlapFactor = 0.35; // Items overlap by ~65% for tight packing
}

