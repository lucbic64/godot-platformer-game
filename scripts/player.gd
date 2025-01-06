extends CharacterBody2D


@export var speed = 300.0
@export var jump_velocity = -400.0

@onready var floor_detection = $FloorDetection
@onready var tile_map = $"../LevelTileMap"

func _process(_delta: float) -> void:
	check_floor_collision()

func check_floor_collision() -> void:
	if floor_detection.overlaps_body(tile_map):
		var map_position: Vector2i = tile_map.local_to_map(tile_map.to_local(global_position))
		map_position.y += 1
		var tile_data: TileData = tile_map.get_cell_tile_data(map_position)
		match tile_data.get_custom_data("GroundProperties"):
			1: print("slow")
			2: print("damage")
			3: print("slippery")

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
