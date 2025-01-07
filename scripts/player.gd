extends CharacterBody2D

@export var player_movement: PlayerMovementData

@onready var floor_detection = $FloorDetection
@onready var tile_map = $"../LevelTileMap"

var gravity: float:
	get():
		return player_movement.jump_gravity if velocity.y < 0 else player_movement.fall_gravity

func pickup_collected(type: Events.Pickups) -> void:
	match type:
		Events.Pickups.COIN:
			print("Coin collected")
		Events.Pickups.ELIXIR:
			print("Elixir collected")
		Events.Pickups.APPLE:
			print("Apple collected")

func _ready() -> void:
	player_movement.calc_jump_values()
	Events.pickup_collected.connect(pickup_collected)

func _process(_delta: float) -> void:
	check_floor_collision()

func check_floor_collision() -> void:
	if floor_detection.overlaps_body(tile_map):
		var global_position_centered = global_position + Vector2(7, 11)
		
		var map_position: Vector2i = tile_map.local_to_map(tile_map.to_local(global_position_centered))
		map_position.y += 1
		
		var tile_data: TileData = tile_map.get_cell_tile_data(map_position)
		if not tile_data: return
		#assert(tile_data, "Tile Data couldn't be fetched!")
		
		match tile_data.get_custom_data("GroundProperties"):
			1: print("slow")
			2: print("damage")
			3: print("slippery")
	else:
		for moving_platform in floor_detection.get_overlapping_bodies():
			if "Brown" in moving_platform.name: print("slow")
			elif "Yellow" in moving_platform.name: print("damage")
			elif "Blue" in moving_platform.name: print("slippery")

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
