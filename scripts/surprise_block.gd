@tool
extends StaticBody2D

@export_enum("Blue", "Yellow", "Brown", "Red") var color: int: set = _set_color

@onready var player_detection = $PlayerDetection
@onready var coin = preload("res://scenes/pickups/coin.tscn")
@onready var elixir = preload("res://scenes/pickups/elixir.tscn")
@onready var apple = preload("res://scenes/pickups/apple.tscn")

var _sprite_region_data: Array[Dictionary] = [
	{"rect_pos": Vector2(112, 32), "offset_to_activated": Vector2(16, 0)},    # Blue
	{"rect_pos": Vector2(48, 32), "offset_to_activated": Vector2(-16, 16)},   # Yellow
	{"rect_pos": Vector2(0, 32), "offset_to_activated": Vector2(16, 0)},      # Brown
	{"rect_pos": Vector2(64, 32), "offset_to_activated": Vector2(16, 0)}      # Red
]

var activated = false
var activated_img := Vector2(16, 0)

func _set_color(new_color: int) -> void:
	color = new_color
	
	$BlockSprite.region_rect.position = _sprite_region_data[color].rect_pos
	activated_img = _sprite_region_data[color].offset_to_activated

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if player_detection.has_overlapping_bodies():
		var player = player_detection.get_overlapping_bodies()[0] as Player
		
		if player.state_machine.current_state is Jump and not activated: activate_block()

func activate_block() -> void:
	var choices: Array[PackedScene] = [coin, elixir, apple]
	var object: Pickup = choices.pick_random().instantiate()
	add_child(object)
	
	object.position = Vector2(8, -8)
	
	$BlockSprite.region_rect.position += activated_img
	activated = true
