@tool
class_name MovingPlatform
extends CharacterBody2D

@export_enum("Blue", "Brown", "Green", "Yellow") var color: int: set = _set_color
@export_enum("Normal", "Small") var size: int: set = _set_size

@export var speed: float = 100
@export_enum("X", "Y") var axis: String = "X"

@export_subgroup("Shapes")
@export var _normal_shape: RectangleShape2D
@export var _small_shape: RectangleShape2D

# Region data to sprites for blue, brown, green and yellow moving platform sprites, respectively.
# Following these are the corresponding regions for the respective colors for small platforms
var _sprite_regions := [
	Rect2(16, 48, 32, 9), Rect2(16, 16, 32, 9), Rect2(16, 0, 32, 9), Rect2(16, 32, 32, 9),
	Rect2(0, 48, 16, 9), Rect2(0, 16, 16, 9), Rect2(0, 0, 16, 9), Rect2(0, 32, 16, 9)
]
var _shape_pos := [16, 8]

var boundaries: Array[float] = [0, 0]
var width: float
var direction: int = 1

func _set_color(new_color: int) -> void:
	color = new_color
	
	$MovingPlatformSprite.region_rect = _sprite_regions[color + 4 * size]

func _set_size(new_size: int) -> void:
	size = new_size
	
	var shape = $MovingPlatformShape
	var sprite = $MovingPlatformSprite
	
	shape.position.x = _shape_pos[size]
	sprite.position.x = _shape_pos[size]
	shape.shape = _small_shape if size else _normal_shape
	sprite.region_rect = _sprite_regions[color + 4 * size]

func _ready() -> void:
	boundaries[0] = $StartPosition.global_position[0 if axis == "X" else 1]
	boundaries[1] = $EndPosition.global_position[0 if axis == "X" else 1]
	
	width = $MovingPlatformSprite.region_rect.size.x

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	velocity[0 if axis == "X" else 1] = direction * speed
	
	if (axis == "X" and (global_position.x < boundaries[0] and direction == -1 or global_position.x > boundaries[1] - width and direction == 1)) or \
	   (axis == "Y" and (global_position.y > boundaries[0] and direction == 1 or global_position.y < boundaries[1] and direction == -1)):
		direction *= -1
	
	move_and_slide()
