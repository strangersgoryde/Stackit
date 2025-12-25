This Design Language Plan (DLP) is curated to ensure the game looks professional, cohesive, and "delicious." For a casual game like **Stack the Snack**, we are using a **"Playful Pop"** aesthetic: high contrast, rounded edges, and a warm, food-centric palette.

---

# 🎨 Design Language Plan: Stack the Snack

## 1. Color Palette

We use a **Warm Analogous** scheme to stimulate appetite, contrasted with a **Cool Action** color for UI elements.

| Category | Hex Code | Usage |
| --- | --- | --- |
| **Primary (Brand)** | `#FF6B6B` | Main buttons, logos, and "Perfect" drop highlights. |
| **Secondary (Gold)** | `#FFD93D` | Stars, high scores, and "Combo" text. |
| **Success (Green)** | `#6BCB77` | "Order Complete" screens and Level Up indicators. |
| **Background (Soft)** | `#FFF9F0` | Game area background (keeps eyes from tiring). |
| **Text (Dark)** | `#2D3436` | Main body text and heavy outlines. |
| **Shadows** | `#636E72` | Subtle drop shadows for depth. |

---

## 2. Typography

To pass Google Play’s quality checks, text must be legible on small screens. Use **Google Fonts** (available via the `google_fonts` Flutter package).

* **Primary Display Font: [Titan One**](https://fonts.google.com/specimen/Titan+One)
* *Style:* Thick, rounded, bubbly.
* *Usage:* Headlines, Scores, "Perfect/Miss" popups.


* **Secondary UI Font: [Quicksand**](https://fonts.google.com/specimen/Quicksand)
* *Style:* Clean, sans-serif, rounded terminals.
* *Usage:* Instructions, Settings menu, Recipe names.



### Font Scaling Table

| Element | Font | Size (pt) | Weight | Color |
| --- | --- | --- | --- | --- |
| **Main Score** | Titan One | 48 | Regular | Primary |
| **Headings** | Titan One | 32 | Regular | Text (Dark) |
| **Button Text** | Quicksand | 20 | Bold | Background (Soft) |
| **Subtitles** | Quicksand | 16 | Medium | Shadow |

---

## 3. Visual Assets & Art Style

**Style: "Thick-Line Flat Art"**

* **Outlines:** All food items must have a **3pt to 5pt** dark brown/charcoal outline (`#2D3436`). This ensures they pop against any background.
* **Shape Language:** Avoid sharp corners. Everything (burgers, cheese slices, plates) should have **rounded corners** (Corner Radius: 8px–12px).
* **Depth:** Use a simple **"Flat Shadow"**—a slightly darker version of the base color on the bottom-right half of each sprite.

---

## 4. UI Components & Layout

* **Buttons:**
* **Shape:** Capsule-shaped (fully rounded sides).
* **Effect:** 4px "Bottom Depth" (a darker shade of the button color underneath) to make it look pressable.


* **The "Stability Meter":**
* A horizontal bar at the top center.
* Gradient from Green (center) to Red (edges).
* A white circle indicator that slides based on the stack's center of mass.


* **The Kitchen Background:**
* Low-contrast. Use a 20% opacity white overlay on background illustrations to ensure the moving food remains the focal point.



---

## 5. Animation Logic (The "Juice")

The developer should implement these three specific movement rules:

1. **The Landing Squish:** When an item hits the stack, use a `ScaleEffect`:
* Scale  to 
* Scale  to 
* Duration: , Curve: `Curves.elasticOut`.


2. **The UI Bounce:** Any menu popup should scale from  to  and settle at .
3. **The "Ghost" Indicator:** A subtle, semi-transparent shadow of the food item should appear directly below it on the moving base to help the player judge the drop.

---

## 6. Implementation Notes for the Developer

* **Asset Management:** Export all sprites as  high-res `.png` (at least 3x scale) to avoid blurriness on high-DPI Android screens.
* **Safety Margins:** Keep all UI elements at least **32px** away from the screen edges to account for different notch designs and rounded phone corners.