@tool
extends Area2D

@export_enum("Brown", "Red") var color: int: set = _set_color

var _region_positions := [Vector2(144, 50), Vector2(144, 66)] # Brown, Red

func _set_color(new_color: int) -> void:
	color = new_color
	
	$LadderSprite.region_rect.position = _region_positions[color]
