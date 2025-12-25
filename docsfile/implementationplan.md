This implementation plan follows a **14-day sprint** designed for developer using **Flutter** and the **Flame engine**. It focuses on the "Moving Base" stacking mechanic and ensures the codebase remains modular for easy expansion.

---

## 🏗️ Phase 1: Core Engine & Physics (Days 1–4)

**Goal:** Establish the rhythmic horizontal movement and the "Attach" logic.

* **Day 1: Project Scaffolding**
* Setup Flutter project and add `flame` and `flame_audio` dependencies.
* Create the `FlameGame` class and a basic `World` and `Camera`.
* Implement a `GameConfig` class to store constants (Base Speed, Drop Gravity, Timing Windows).


* **Day 2: The Oscillating Base**
* Create a `MovingBase` component.
* Implement horizontal movement logic using a `Sine` function or simple velocity inversion when hitting screen edges.
* Ensure the camera tracks the *top* of the stack, not the screen origin.


* **Day 3: The Drop Mechanic**
* Create a `FallingIngredient` component.
* Implement `TapDetector`: On tap, spawn an ingredient at the top that falls vertically.
* **Collision Detection:** Use Flame’s `CollisionCallbacks`.


* **Day 4: Stacking & Parenting**
* Logic: When `FallingIngredient` hits `MovingBase`, remove it from the World and add it as a child of `MovingBase`.
* Update the `MovingBase` hitbox/height dynamically so the next item lands on the *new* top.



---

## 🎨 Phase 2: Game Rules & Progression (Days 5–8)

**Goal:** Turn the mechanic into a "Game" with win/loss states.

* **Day 5: Precision Logic (The "Trim" System)**
* Calculate the X-axis offset upon landing.
* **Success:** If offset < , play "Perfect" effect.
* **Failure:** If offset > , trigger the "Topple" physics and Game Over.


* **Day 6: Recipe & Level Manager**
* Create a `Recipe` model using the asset naming convention:
  * Burger: `[burger_bun_bottom, burger_patty, burger_cheese, burger_lettuce, burger_bun_top]`
  * Breakfast: `[breakfast_plate, breakfast_pancakes, breakfast_egg, breakfast_whipped_cream]`
  * Donut: `[donut_napkin, donut_glazed, donut_pink, donut_chocolate]`
  * Sundae: `[sundae_bowl, sundae_vanilla, sundae_strawberry, sundae_mint, sundae_cherry]`
  * Cake: `[cake_stand, cake_large, cake_medium, cake_small, cake_candle]`
* Implement a `LevelManager` that increases the `MovingBase` speed as each ingredient is added.


* **Day 7: Timer & Attempts**
* Add a "Kitchen Timer" (Progress Bar). If it reaches zero before the next drop, the game fails.
* Implement a "Lives" system (e.g., 3 missed ingredients allowed before total failure).


* **Day 8: State Management**
* Implement `GameStates`: `Menu`, `Playing`, `LevelComplete`, `GameOver`.
* Connect Flame game events to the Flutter UI for menus.



---

## 🍬 Phase 3: Visual Juice & Polish (Days 9–12)

**Goal:** Make the game look professional to pass Google Play quality checks.

* **Day 9: "Squash & Stretch" Animations**
* Use Flame `Effects` (specifically `ScaleEffect`) to make items "squish" when they land.
* Add a slight "wobble" effect to the stack if the landing isn't perfect.


* **Day 10: Particle Systems**
* Add `ParticleSystemComponent` for "Perfect" landings (star bursts) and "Misses" (smoke/dust).


* **Day 11: Audio Implementation**
* **SFX:** Different sounds for "Thud" (meat), "Crunch" (lettuce), and "Ding" (success).
* **BGM:** Implement a simple, non-distracting background loop.


* **Day 12: Theme & Backgrounds**
* Add a `ParallaxComponent` for the kitchen background.
* Implement "Visual Progression": The background lighting changes as the stack gets higher.



---

## 🚀 Phase 4: Final Polish & Deployment (Days 13–14)

**Goal:** Prepare for the Google Play Store.

* **Day 13: Local Persistence & Testing**
* Use `shared_preferences` to save High Scores and unlocked Recipes.
* Test on different screen aspect ratios (Tablet vs. Phone).
* Use the our logo, make sure taht we are not using any default flutter logo.


Must have:
- Fail and win screens
- Play and pause functionality
- Privacy policy
- Game guide

---

## 📦 Asset Reference

### Image Assets (`assets/images/`)

| Category | Asset Name | Description |
|----------|------------|-------------|
| **Burger** | `burger_bun_bottom.png` | Bottom bun (base) |
| | `burger_patty.png` | Grilled meat patty |
| | `burger_cheese.png` | Cheese slice |
| | `burger_lettuce.png` | Lettuce leaf |
| | `burger_tomato.png` | Tomato slice |
| | `burger_bacon.png` | Bacon strip |
| | `burger_onion_ring.png` | Onion ring |
| | `burger_bun_top.png` | Top bun with sesame seeds |
| **Breakfast** | `breakfast_plate.png` | Plate (base) |
| | `breakfast_pancakes.png` | Pancake stack with butter |
| | `breakfast_waffle.png` | Waffle |
| | `breakfast_egg.png` | Fried egg |
| | `breakfast_sausage.png` | Sausage |
| | `breakfast_toast.png` | Toast slice |
| | `breakfast_butter.png` | Butter pat |
| | `breakfast_strawberry.png` | Strawberry |
| | `breakfast_whipped_cream.png` | Whipped cream |
| **Donut** | `donut_napkin.png` | Napkin (base) |
| | `donut_glazed.png` | Glazed donut |
| | `donut_pink.png` | Pink frosted donut with sprinkles |
| | `donut_chocolate.png` | Chocolate donut |
| **Sundae** | `sundae_bowl.png` | Sundae bowl (base) |
| | `sundae_vanilla.png` | Vanilla ice cream scoop |
| | `sundae_strawberry.png` | Strawberry ice cream scoop |
| | `sundae_mint.png` | Mint ice cream scoop |
| | `sundae_cherry.png` | Cherry topper |
| **Cake** | `cake_stand.png` | 3-tier cake stand (base) |
| | `cake_large.png` | Large cake layer |
| | `cake_medium.png` | Medium cake layer |
| | `cake_small.png` | Small cake layer |
| | `cake_candle.png` | Birthday candle (topper) |
| **Background** | `bg_kitchen.png` | Kitchen background |

### Audio Assets (`assets/audios/`)

| Asset Name | Type | Usage |
|------------|------|-------|
| `BGM.ogg` | Music | Gameplay background music |
| `Menu.ogg` | Music | Menu screen background music |
| `squish.ogg` | SFX | Landing squish effect |
| `thud.ogg` | SFX | Heavy item landing |
| `thud2.ogg` | SFX | Alternative landing sound |
| `pop.ogg` | SFX | General pop effect |
| `Perfect.ogg` | SFX | Perfect alignment celebration |
| `Victory.ogg` | SFX | Level complete fanfare |
| `fail.ogg` | SFX | Game over sound |
| `Warning.ogg` | SFX | Timer warning alert |

### Font Assets (`assets/fonts/`)

| Font | Weights Available | Usage |
|------|-------------------|-------|
| **Titan One** | Regular | Headlines, Scores, "Perfect/Miss" popups |
| **Quicksand** | Light, Regular, Medium, SemiBold, Bold, Variable | UI text, Instructions, Settings, Recipe names |

---

