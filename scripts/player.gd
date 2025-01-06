extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -400.0
@onready var floor_detection = $FloorDetection

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
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
