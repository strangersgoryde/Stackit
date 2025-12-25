enum SnackCategory { burger, breakfast, donut, sundae, cake }

class Recipe {
  final SnackCategory category;
  final String name;
  final List<String> ingredients;
  final int levelId;

  const Recipe({
    required this.category,
    required this.name,
    required this.ingredients,
    required this.levelId,
  });

  // Helper to get the base (bottom item)
  String get baseIngredient => ingredients.first;
  
  // Helper to get remaining items to drop
  List<String> get droppableIngredients => ingredients.sublist(1);
}

class RecipeBook {
  static const List<Recipe> recipes = [
    // 🍔 Burger Recipes
    Recipe(
      levelId: 1,
      category: SnackCategory.burger,
      name: "The Slider",
      ingredients: ['burger_bun_bottom.png', 'burger_patty.png', 'burger_bun_top.png'],
    ),
    Recipe(
      levelId: 2,
      category: SnackCategory.burger,
      name: "Classic Burger",
      ingredients: ['burger_bun_bottom.png', 'burger_patty.png', 'burger_cheese.png', 'burger_lettuce.png', 'burger_bun_top.png'],
    ),
    Recipe(
      levelId: 3,
      category: SnackCategory.burger,
      name: "Deluxe Burger",
      ingredients: ['burger_bun_bottom.png', 'burger_patty.png', 'burger_cheese.png', 'burger_bacon.png', 'burger_tomato.png', 'burger_lettuce.png', 'burger_bun_top.png'],
    ),
    Recipe(
      levelId: 4,
      category: SnackCategory.burger,
      name: "Mega Burger",
      ingredients: ['burger_bun_bottom.png', 'burger_patty.png', 'burger_cheese.png', 'burger_onion_ring.png', 'burger_bacon.png', 'burger_patty.png', 'burger_tomato.png', 'burger_lettuce.png', 'burger_bun_top.png'],
    ),

    // 🥞 Breakfast Recipes
    Recipe(
      levelId: 5,
      category: SnackCategory.breakfast,
      name: "Simple Breakfast",
      ingredients: ['breakfast_plate.png', 'breakfast_pancakes.png', 'breakfast_butter.png', 'breakfast_strawberry.png'],
    ),
    Recipe(
      levelId: 6,
      category: SnackCategory.breakfast,
      name: "Waffle Stack",
      ingredients: ['breakfast_plate.png', 'breakfast_waffle.png', 'breakfast_egg.png', 'breakfast_sausage.png', 'breakfast_whipped_cream.png'],
    ),
    Recipe(
      levelId: 7,
      category: SnackCategory.breakfast,
      name: "Grand Breakfast",
      ingredients: ['breakfast_plate.png', 'breakfast_pancakes.png', 'breakfast_egg.png', 'burger_bacon.png', 'breakfast_toast.png', 'breakfast_butter.png', 'breakfast_strawberry.png'],
    ),

    // 🍩 Donut Recipes
    Recipe(
      levelId: 8,
      category: SnackCategory.donut,
      name: "Donut Duo",
      ingredients: ['donut_napkin.png', 'donut_glazed.png', 'donut_pink.png'],
    ),
    Recipe(
      levelId: 9,
      category: SnackCategory.donut,
      name: "Donut Tower",
      ingredients: ['donut_napkin.png', 'donut_chocolate.png', 'donut_glazed.png', 'donut_pink.png'],
    ),

    // 🍨 Sundae Recipes
    Recipe(
      levelId: 10,
      category: SnackCategory.sundae,
      name: "Classic Sundae",
      ingredients: ['sundae_bowl.png', 'sundae_vanilla.png', 'sundae_strawberry.png', 'sundae_cherry.png'],
    ),
    Recipe(
      levelId: 11,
      category: SnackCategory.sundae,
      name: "Triple Scoop",
      ingredients: ['sundae_bowl.png', 'sundae_vanilla.png', 'sundae_strawberry.png', 'sundae_mint.png', 'sundae_cherry.png'],
    ),

    // 🎂 Cake Recipes
    Recipe(
      levelId: 12,
      category: SnackCategory.cake,
      name: "Petite Cake",
      ingredients: ['cake_stand.png', 'cake_small.png', 'cake_candle.png'],
    ),
    Recipe(
      levelId: 13,
      category: SnackCategory.cake,
      name: "Tiered Cake",
      ingredients: ['cake_stand.png', 'cake_large.png', 'cake_medium.png', 'cake_candle.png'],
    ),
    Recipe(
      levelId: 14,
      category: SnackCategory.cake,
      name: "Grand Celebration",
      ingredients: ['cake_stand.png', 'cake_large.png', 'cake_medium.png', 'cake_small.png', 'cake_candle.png'],
    ),

    // 🏆 Master Levels - Ultimate Challenges!
    Recipe(
      levelId: 15,
      category: SnackCategory.burger,
      name: "Ultimate Burger",
      ingredients: [
        'burger_bun_bottom.png', 'burger_patty.png', 'burger_cheese.png', 
        'burger_bacon.png', 'burger_patty.png', 'burger_cheese.png',
        'burger_onion_ring.png', 'burger_tomato.png', 'burger_lettuce.png', 
        'burger_bun_top.png'
      ],
    ),
    Recipe(
      levelId: 16,
      category: SnackCategory.breakfast,
      name: "Brunch Supreme",
      ingredients: [
        'breakfast_plate.png', 'breakfast_pancakes.png', 'breakfast_butter.png',
        'breakfast_egg.png', 'burger_bacon.png', 'breakfast_waffle.png',
        'breakfast_sausage.png', 'breakfast_strawberry.png', 'breakfast_whipped_cream.png'
      ],
    ),
    Recipe(
      levelId: 17,
      category: SnackCategory.sundae,
      name: "Sundae Supreme",
      ingredients: [
        'sundae_bowl.png', 'sundae_vanilla.png', 'sundae_strawberry.png',
        'sundae_mint.png', 'sundae_vanilla.png', 'sundae_strawberry.png',
        'sundae_cherry.png'
      ],
    ),
  ];
}

