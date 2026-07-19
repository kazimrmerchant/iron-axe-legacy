extends CharacterBody2D
class_name Player

# ========== STATS ==========
@export var move_speed: float = 220.0
@export var jump_force: float = 420.0
@export var gravity: float = 1400.0
@export var max_health: int = 100
@export var max_magic: int = 100

var health: int
var magic: int
var facing_right: bool = true
var is_attacking: bool = false
var can_move: bool = true

# ========== NODES ==========
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var hurtbox: Area2D = $Hurtbox
@onready var state_machine: Node = $StateMachine

func _ready() -> void:
	health = max_health
	magic = max_magic
	hitbox.monitoring = false

func _physics_process(delta: float) -> void:
	if not can_move:
		return

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Horizontal movement
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0 and not is_attacking:
		velocity.x = direction * move_speed
		facing_right = direction > 0
		sprite.flip_h = not facing_right
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_attacking:
		velocity.y = -jump_force

	move_and_slide()

	# Attack inputs
	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack("light")
	elif Input.is_action_just_pressed("special") and not is_attacking:
		start_attack("special")
	elif Input.is_action_just_pressed("magic") and magic >= 30 and not is_attacking:
		cast_magic()

func start_attack(type: String) -> void:
	is_attacking = true
	can_move = false
	velocity.x = 0

	match type:
		"light":
			sprite.play("attack_light")
			await get_tree().create_timer(0.15).timeout
			enable_hitbox(15, Vector2(40, 0))
			await get_tree().create_timer(0.2).timeout
			disable_hitbox()
		"special":
			sprite.play("attack_special")
			await get_tree().create_timer(0.25).timeout
			enable_hitbox(30, Vector2(50, 0))
			await get_tree().create_timer(0.3).timeout
			disable_hitbox()

	is_attacking = false
	can_move = true
	sprite.play("idle")

func cast_magic() -> void:
	magic -= 30
	is_attacking = true
	can_move = false
	sprite.play("magic")
	# TODO: Spawn magic effect
	await get_tree().create_timer(0.6).timeout
	is_attacking = false
	can_move = true
	sprite.play("idle")

func enable_hitbox(damage: int, offset: Vector2) -> void:
	hitbox.monitoring = true
	hitbox.position.x = offset.x if facing_right else -offset.x
	# Store damage for the hitbox to use
	hitbox.set_meta("damage", damage)

func disable_hitbox() -> void:
	hitbox.monitoring = false

func take_damage(amount: int, knockback: Vector2 = Vector2.ZERO) -> void:
	health -= amount
	health = max(health, 0)
	# Apply knockback
	velocity = knockback
	if health <= 0:
		die()

func die() -> void:
	can_move = false
	sprite.play("death")
	# TODO: Game over logic
	print("Player died")

func heal(amount: int) -> void:
	health = min(health + amount, max_health)

func restore_magic(amount: int) -> void:
	magic = min(magic + amount, max_magic)
