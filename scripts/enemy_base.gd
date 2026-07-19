extends CharacterBody2D
class_name EnemyBase

@export var max_health: int = 40
@export var move_speed: float = 80.0
@export var attack_damage: int = 10
@export var detection_range: float = 300.0
@export var attack_range: float = 50.0

var health: int
var player: Node2D = null
var facing_right: bool = true
var is_attacking: bool = false
var is_dead: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var hurtbox: Area2D = $Hurtbox

enum State { IDLE, CHASE, ATTACK, HURT, DEAD }
var current_state: State = State.IDLE

func _ready() -> void:
	health = max_health
	hitbox.monitoring = false
	# Find player
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	match current_state:
		State.IDLE:
			_state_idle()
		State.CHASE:
			_state_chase(delta)
		State.ATTACK:
			pass  # Handled by attack function
		State.HURT:
			pass

	move_and_slide()

func _state_idle() -> void:
	velocity.x = 0
	sprite.play("idle")
	if player and global_position.distance_to(player.global_position) < detection_range:
		current_state = State.CHASE

func _state_chase(delta: float) -> void:
	if not player:
		current_state = State.IDLE
		return

	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * move_speed
	facing_right = direction > 0
	sprite.flip_h = not facing_right
	sprite.play("walk")

	if global_position.distance_to(player.global_position) < attack_range:
		start_attack()

func start_attack() -> void:
	if is_attacking:
		return
	current_state = State.ATTACK
	is_attacking = true
	velocity.x = 0
	sprite.play("attack")

	await get_tree().create_timer(0.3).timeout
	enable_hitbox()
	await get_tree().create_timer(0.2).timeout
	disable_hitbox()
	await get_tree().create_timer(0.3).timeout

	is_attacking = false
	current_state = State.CHASE

func enable_hitbox() -> void:
	hitbox.monitoring = true
	hitbox.set_meta("damage", attack_damage)

func disable_hitbox() -> void:
	hitbox.monitoring = false

func take_damage(amount: int, knockback: Vector2 = Vector2.ZERO) -> void:
	if is_dead:
		return
	health -= amount
	velocity = knockback
	current_state = State.HURT
	sprite.play("hurt")

	if health <= 0:
		die()
	else:
		await get_tree().create_timer(0.3).timeout
		current_state = State.CHASE

func die() -> void:
	is_dead = true
	current_state = State.DEAD
	velocity = Vector2.ZERO
	sprite.play("death")
	hurtbox.set_deferred("monitorable", false)
	hitbox.set_deferred("monitoring", false)
	# Drop item chance, score, etc. can go here
	await sprite.animation_finished
	queue_free()
