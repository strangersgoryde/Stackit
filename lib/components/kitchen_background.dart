import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class KitchenBackground extends ParallaxComponent {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // We want the background to be fixed to the camera view (viewport)
    // so it doesn't scroll off when we climb the stack.
    // However, we want a "Parallax" effect where it might scroll slightly or repeat.
    // Setting priority to -1 ensures it's behind everything.
    priority = -10; 
    
    parallax = await game.loadParallax(
      [
        ParallaxImageData('bg_kitchen.png'),
      ],
      baseVelocity: Vector2(0, 0), // Static relative to camera frame
      repeat: ImageRepeat.repeat,
      fill: LayerFill.width,
    );
  }
}
