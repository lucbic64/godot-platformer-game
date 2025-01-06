extends CharacterBody2D

@export var player_movement: PlayerMovementData

@onready var floor_detection = $FloorDetection

var gravity: float:
	get():
		return player_movement.jump_gravity if velocity.y < 0 else player_movement.fall_gravity

func _ready() -> void:
	player_movement.calc_jump_values()

func _process(_delta: float) -> void:
	check_floor_collision()

func check_floor_collision() -> void:
	var bodies = floor_detection.get_overlapping_bodies()
	bodies = bodies.filter(func(element):
		return element.name.begins_with("MovingPlatform")
	)
	match bodies.size():
		1:
			var moving_platform = bodies[0]
			check_moving_platform_type(moving_platform)
		2:
			for moving_platform in bodies:
				check_moving_platform_type(moving_platform)

func check_moving_platform_type(moving_platform: Node2D) -> void:
	if "Blue" in moving_platform.name:
		print("slippery")
	elif "Brown" in moving_platform.name:
		print("slow")
	elif "Yellow" in moving_platform.name:
		print("damage")

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
