extends Camera2D

@export var target: Node2D
@export var smooth_speed: float = 5.0
@export var look_ahead: float = 80.0

var trauma: float = 0.0
var trauma_power: int = 2

func _ready() -> void:
	if not target:
		target = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if not target:
		return

	var target_pos = target.global_position
	# Simple look-ahead based on facing
	if target.has_method("get") and "facing_right" in target:
		target_pos.x += look_ahead if target.facing_right else -look_ahead

	global_position = global_position.lerp(target_pos, smooth_speed * delta)

	# Screen shake
	if trauma > 0:
		trauma = max(trauma - delta * 1.5, 0)
		var amount = pow(trauma, trauma_power)
		offset = Vector2(
			randf_range(-1, 1) * amount * 15,
			randf_range(-1, 1) * amount * 15
		)
	else:
		offset = Vector2.ZERO

func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)
