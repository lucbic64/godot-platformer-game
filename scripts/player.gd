class_name Player
extends CharacterBody2D

@export var player_movement: PlayerMovementData
@export var tile_map: TileMapLayer

@onready var player_sprite = $PlayerSprite
@onready var floor_detection = $FloorDetection
@onready var state_machine = $StateMachine

var gravity: float:
	get():
		return player_movement.jump_gravity if velocity.y < 0 else player_movement.fall_gravity

func _ready() -> void:
	player_movement.calc_jump_values()
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	check_floor_collision()
	state_machine.process_frame(delta)

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
