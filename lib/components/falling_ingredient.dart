import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../game/stack_the_snack_game.dart';
import '../game/particle_helper.dart';
import '../game/audio_manager.dart';
import 'moving_base.dart';

class FallingIngredient extends SpriteComponent
    with HasGameReference<StackTheSnackGame>, CollisionCallbacks {
  double _verticalSpeed = 0;
  final String spriteName;
  bool _hasLanded = false;

  FallingIngredient({required this.spriteName, super.position})
    : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await game.loadSprite(spriteName);
    if (sprite != null) {
      // Scale down the ingredient size based on current level/endless progress
      size = sprite!.srcSize * game.levelManager.currentIngredientScale;
    }

    add(RectangleHitbox(size: size, isSolid: true));
  }

  @override
  void update(double dt) {
    if (_hasLanded) return;

    super.update(dt);

    // Use level-dependent gravity (faster in early levels = easier)
    final gravity = game.levelManager.currentDropGravity;
    _verticalSpeed += gravity * dt;
    position.y += _verticalSpeed * dt;

    if (game.movingBase != null) {
      final missY = game.movingBase!.position.y + 200;
      if (position.y > missY) {
        _handleMiss();
      }
    }
  }

  void _handleMiss() {
    _hasLanded = true; // Stop updating
    removeFromParent();

    AudioManager.playSfx('pop.ogg'); // Miss sound

    // Miss Particles
    game.world.add(ParticleHelper.createMissParticles(position));

    // This counts as a failed attempt (not instant game over)
    game.levelManager.onAttemptFailed();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (_hasLanded) return;

    if (other is MovingBase) {
      _hasLanded = true;
      other.stackItem(this);
      removeFromParent();
    }
  }
}
