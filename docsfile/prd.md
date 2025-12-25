# 📄 Product Requirements Document (PRD): Stack the Snack

## 1. Executive Summary

**Stack the Snack** is a precision-timing 2D game where players build complex food items (Burgers, Breakfast Stacks, Donuts, Sundaes, Cakes) on a **constantly moving platform**. It combines the tension of a rhythm game with the satisfaction of physics-based stacking.

---

## 2. Updated Core Gameplay Mechanics

### 2.1 The "Continuous Motion" Base

* **The Movement:** The base (e.g., the bottom bun or plate) slides horizontally back and forth across the bottom of the screen.
* **The Follower:** When a new item is successfully stacked, it becomes part of the "moving base." The entire stack moves together as a single unit.
* **The Challenge:** The player must time the release of the *next* ingredient from the top to land on the moving stack below.

### 2.2 Precision Scoring & Physics

* **Perfect Alignment:** If the dropped item aligns perfectly with the stack, the stack remains stable.
* **Off-Center Hits:** If an item lands partially off the edge, the overhanging part "breaks off" (visually) or causes the stack to become narrower/more unstable for the next drop.
* **Game Over Condition:** 
  1. The item misses the moving base entirely.
  2. The player fails to drop the item within a specific "Order Timer."

---

## 3. Level Design & Progression

### 3.1 The "Recipe" System

Instead of an endless mode, the game is divided into **Level-Based Recipes** across 5 food categories:

#### 🍔 Burger Recipes
* **Level 1 (The Slider):** 3 items (Bottom Bun → Patty → Top Bun). Slow movement.
* **Level 2 (Classic Burger):** 5 items (Bottom Bun → Patty → Cheese → Lettuce → Top Bun). Slow movement.
* **Level 3 (Deluxe Burger):** 7 items (Bottom Bun → Patty → Cheese → Bacon → Tomato → Lettuce → Top Bun). Medium speed.
* **Level 4 (Mega Burger):** 9 items (Bottom Bun → Patty → Cheese → Onion Ring → Bacon → Patty → Tomato → Lettuce → Top Bun). Medium speed.

#### 🥞 Breakfast Recipes
* **Level 5 (Simple Breakfast):** 4 items (Plate → Pancakes → Butter → Strawberry). Slow movement.
* **Level 6 (Waffle Stack):** 5 items (Plate → Waffle → Egg → Sausage → Whipped Cream). Medium speed.
* **Level 7 (Grand Breakfast):** 7 items (Plate → Pancakes → Egg → Bacon → Toast → Butter → Strawberry). Medium speed.

#### 🍩 Donut Recipes
* **Level 8 (Donut Duo):** 3 items (Napkin → Glazed Donut → Pink Donut). Medium speed.
* **Level 9 (Donut Tower):** 4 items (Napkin → Chocolate Donut → Glazed Donut → Pink Donut). Fast movement.

#### 🍨 Sundae Recipes
* **Level 10 (Classic Sundae):** 4 items (Bowl → Vanilla Scoop → Strawberry Scoop → Cherry). Medium speed.
* **Level 11 (Triple Scoop):** 5 items (Bowl → Vanilla Scoop → Strawberry Scoop → Mint Scoop → Cherry). Fast movement.

#### 🎂 Cake Recipes
* **Level 12 (Petite Cake):** 3 items (Cake Stand → Small Cake → Candle). Medium speed.
* **Level 13 (Tiered Cake):** 4 items (Cake Stand → Large Cake → Medium Cake → Candle). Fast movement.
* **Level 14 (Grand Celebration):** 5 items (Cake Stand → Large Cake → Medium Cake → Small Cake → Candle). Fast movement.

### 3.2 Difficulty Scaling

* **Dynamic Speed:** Every 2 items stacked in a single level, the horizontal speed increases slightly.
* **Oscillation Patterns:** In higher levels, the base doesn't just move at a constant speed; it may slow down at the edges or "dash" across the center.

---

## 4. Feature Set

### 4.1 Progression & Unlocks

* **Chef Ranks:** Players earn "Stars" based on how centered their stacks are. Total stars unlock higher "Kitchens" (Street Food, Fine Dining, Galactic Cafe).
* **Gallery:** A "Recipe Book" that shows all the completed food items the player has successfully built.

### 4.2 The "Juice" (Polish)

* **The "SQUISH" Factor:** When an item lands, the stack should compress slightly (using Flame’s `ScaleEffect`) to give a feeling of weight.
* **Dynamic Backgrounds:** The background color shifts slightly as the stack gets higher, giving a sense of verticality.

---

## 5. Technical Implementation (Flutter + Flame)

### 5.1 Physics Logic

* **Kinematic Bodies:** The moving stack should be a `PositionComponent`.
* **Collision Detection:** Use Flame’s `CollisionCallbacks`. Upon collision, the falling ingredient's `x-position` is compared to the stack's `x-position`.
* **The "Trim" Logic:** 


If , the "Good" area of the next piece is reduced.

### 5.2 Game Loop States

1. **Prep:** Show the "Target Recipe" (e.g., "Build a BLT").
2. **Play:** Active stacking loop.
3. **Success:** A "glitter" effect over the finished food + a snapshot for the Gallery.
4. **Fail:** The stack topples over with a "sad trombone" sound.

---

## 6. Visual Style

* **Art:** High-contrast 2D vector art. Bold outlines help players judge distances better on small screens.
* **UI:** Minimalist. A "Height Meter" on the right and an "Order Timer" bar at the top.

---

## 7. Development Roadmap (2-Week Sprint)

* **Week 1 (Core):**
  * Create the `MovingBase` component.
  * Implement `Tap-to-Drop` logic.
  * Build the "Attaching" logic (making the dropped item follow the base).

* **Week 2 (Content & Polish):**
  * Design 14 Recipes across 5 categories (Burger, Breakfast, Donut, Sundae, Cake).
  * Add Speed scaling.
  * Implement "Game Over" and "Success" screens.
  * Add SFX (squish, thud, perfect landing sounds).


