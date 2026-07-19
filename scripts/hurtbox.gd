extends Area2D
class_name Hurtbox

# Attach this to any character that can take damage

signal damage_taken(amount, knockback)

func take_damage(amount: int, knockback: Vector2 = Vector2.ZERO) -> void:
	if owner.has_method("take_damage"):
		owner.take_damage(amount, knockback)
	damage_taken.emit(amount, knockback)
