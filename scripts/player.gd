class_name Player
extends CharacterBody2D

@export var player_movement: PlayerMovementData
@export var tile_map: TileMapLayer

@onready var player_sprite = $PlayerSprite
@onready var floor_detection = $FloorDetection
@onready var state_machine = $StateMachine

func _ready() -> void:
	Events.pickup_collected.connect(pickup_collected)
	player_movement.calc_jump_values()
	state_machine.init(self)

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
			2: print("damage")
			3: print("slippery")
	else:
		var moving_platforms = floor_detection.get_overlapping_bodies().filter(func(element):
			return element is MovingPlatform
		) as Array[MovingPlatform]
		
		for moving_platform in moving_platforms:
			match moving_platform.color:
				1: print("slow")
				3: print("damage")
				0: print("slippery")
