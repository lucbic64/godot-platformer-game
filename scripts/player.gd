extends CharacterBody2D

@export var player_movement: PlayerMovementData

var gravity: float:
	get():
		return player_movement.jump_gravity if velocity.y < 0 else player_movement.fall_gravity

func _ready() -> void:
	player_movement.calc_jump_values()

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = move_toward(
			velocity.x,
			player_movement.max_speed * direction,
			player_movement.acceleration * delta
		)
	else:
		velocity.x = lerp(
			velocity.x,
			0.0,
			(player_movement.friction if is_on_floor() else player_movement.air_friction) * delta
		)

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = player_movement.jump_velocity
	
	move_and_slide()
