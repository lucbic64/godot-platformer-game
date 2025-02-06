@tool
extends Node2D

@export_enum("Brown", "Yellow", "Red") var color: int: set = _set_color
@export var instable: bool:
	set(value):
		instable = value
		$GPUParticles2D.emitting = value
		notify_property_list_changed()

## The total time the player has to be on the bridge to make it collapse (Default: 0.2)
var collapsing_time: float = 0.2 # exported if instable
## The time delay after which the collapse continues with the next bridge part falling (Default: 0.2)
var fall_delay: float = 0.2 # exported if instable
## The order in which the bridge parts collapse (Default: Left-to-Right)
var collapse_order: int # exported if instable

@onready var player_detection = $PlayerDetection
@onready var collapse_timer = $CollapseTimer
@onready var particles = $GPUParticles2D
@onready var left_part = $Left
@onready var mid_part = $Mid
@onready var right_part = $Right

# Brown, Yellow, Red
var _region_positions := [Vector2(144, 0), Vector2(144, 16), Vector2(144, 32)]
var _particle_colors := [Color(0.714, 0.42, 0.227), Color(0.765, 0.667, 0.514), Color(0.71, 0.42, 0.373)]

var collapsed = false

func _set_color(new_color: int) -> void:
	color = new_color
	
	particles.modulate = _particle_colors[color]
	
	%BridgeSpriteLeft.region_rect.position = _region_positions[color]
	%BridgeSpriteMid.region_rect.position = _region_positions[color] + Vector2(16, 0)
	%BridgeSpriteRight.region_rect.position = _region_positions[color] + Vector2(32, 0)

func _get_property_list() -> Array[Dictionary]:
	if not Engine.is_editor_hint(): return []
	
	var ret: Array[Dictionary]
	if instable:
		ret.append({
			"name": &"collapsing_time",
			"class_name": &"",
			"type": 3,
			"hint": 0,
			"hint_string": "",
			"usage": 4102
		})
		
		ret.append({
			"name": &"fall_delay",
			"class_name": &"",
			"type": 3,
			"hint": 0,
			"hint_string": "",
			"usage": 4102
		})
		
		ret.append({
			"name": &"collapse_order",
			"class_name": &"",
			"type": 2,
			"hint": 2,
			"hint_string": "Left-to-Right,Right-to-Left",
			"usage": 4102
		})
	
	return ret

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or not instable or collapsed: return
	
	if player_detection.has_overlapping_bodies():
		if collapse_timer.is_stopped(): collapse_timer.start(collapsing_time)
		
		collapse_timer.paused = false
	elif not collapse_timer.is_stopped():
		collapse_timer.paused = true

func collapse() -> void:
	collapsed = true
	particles.emitting = false
	
	if collapse_order:
		right_part.freeze = false
		await get_tree().create_timer(fall_delay).timeout
		mid_part.freeze = false
		await get_tree().create_timer(fall_delay).timeout
		left_part.freeze = false
	else:
		left_part.freeze = false
		await get_tree().create_timer(fall_delay).timeout
		mid_part.freeze = false
		await get_tree().create_timer(fall_delay).timeout
		right_part.freeze = false
