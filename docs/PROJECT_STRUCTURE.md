# Project Structure - Iron Axe: Legacy

## Current Status (Foundation Complete)

### Scripts
- `scripts/player.gd` → Full player controller (movement, jump, light/special attacks, magic)
- `scripts/enemy_base.gd` → Base enemy AI (idle → chase → attack)
- `scripts/hitbox.gd` → Damage dealing system
- `scripts/hurtbox.gd` → Damage receiving system
- `scripts/camera_controller.gd` → Smooth follow + look-ahead + screen shake

### Next Steps to Make it Playable
1. Create `scenes/player.tscn` (CharacterBody2D + AnimatedSprite2D + Hitbox + Hurtbox)
2. Create `scenes/enemy_grunt.tscn` (instance of EnemyBase)
3. Create `scenes/main.tscn` (level + player + camera + a few enemies)
4. Add placeholder sprites (or colored rectangles for now)
5. Wire collision layers properly

### Planned Systems
- [ ] Character select (Ragnar / Lyra / Vex)
- [ ] Combo system & cancel windows
- [ ] Magic effects & screen-clearing spells
- [ ] Multiple enemy types
- [ ] Stage progression & spawners
- [ ] UI (health bars, magic meter, score)
- [ ] Sound effects & music
- [ ] Parallax backgrounds
- [ ] Item drops (food, magic potions)

## How to Expand
Just tell me which system you want next and I will push clean, production-ready code for it.
