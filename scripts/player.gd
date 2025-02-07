class_name Player
extends CharacterBody2D

@export var player_movement: PlayerMovementData
@export var player_data: PlayerData
@export var tile_map: TileMapLayer

@onready var player_sprite = $PlayerSprite
@onready var floor_detection = $FloorDetection
@onready var state_machine = $StateMachine

func _ready() -> void:
	Events.pickup_collected.connect(pickup_collected)
	player_movement.calc_jump_values()
	state_machine.init(self)
	player_data.health = player_data.start_health
	player_data.lives = player_data.start_lives

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	check_floor_collision()
	state_machine.process_frame(delta)

func pickup_collected(type: Events.Pickups) -> void:
	match type:
		Events.Pickups.COIN:
			print("Coin collected")
		Events.Pickups.ELIXIR:
			print("Elixir collected")
		Events.Pickups.APPLE:
			print("Apple collected")

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
			2: damage(1)
			3: print("slippery")
	else:
		for moving_platform in floor_detection.get_overlapping_bodies():
			if "Brown" in moving_platform.name: print("slow")
			elif "Yellow" in moving_platform.name: print("damage")
			elif "Blue" in moving_platform.name: print("slippery")

func heal(hp: int) -> void:
	if player_data.health == player_data.max_health:
		return
	else:
		player_data.health = mini(player_data.health + hp, player_data.max_health)

func damage(hp: int) -> void:
	player_data.health -= hp
	if player_data.health <= 0:
		player_data.lives = player_data.lives - 1
		death() # Provisional implementation
		player_data.health = 100

func death() -> void:
	print(player_data.lives)
	if player_data.lives < 1:
		Events.player_died.emit(self)
