import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ParticleHelper {
  static Component createPerfectParticles(Vector2 position) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 1.0,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 100),
          speed: Vector2(
            (Random().nextDouble() - 0.5) * 200,
            (Random().nextDouble() - 0.5) * 200,
          ),
          position: position,
          child: CircleParticle(
            radius: 4,
            paint: Paint()..color = Colors.amber,
          ),
        ),
      ),
    );
  }
  
  static Component createMissParticles(Vector2 position) {
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 15,
        lifespan: 0.8,
        generator: (i) => AcceleratedParticle(
          speed: Vector2(
            (Random().nextDouble() - 0.5) * 100,
            (Random().nextDouble() * -100), // Upwards
          ),
          position: position,
          child: CircleParticle(
            radius: 3,
            paint: Paint()..color = Colors.grey.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

