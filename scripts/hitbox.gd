extends Area2D
class_name Hitbox

# Attach this script to any Hitbox Area2D
# It automatically deals damage to Hurtboxes it overlaps

signal hit_landed(target, damage)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		var damage = get_meta("damage", 10)
		var knockback_dir = Vector2.RIGHT if owner.facing_right else Vector2.LEFT
		var knockback = knockback_dir * 200.0

		area.take_damage(damage, knockback)
		hit_landed.emit(area.owner, damage)

		# Simple hitstop / juice can be added here later
