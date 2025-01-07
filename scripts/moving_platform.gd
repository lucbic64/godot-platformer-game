extends CharacterBody2D

@export var speed: float = 100
@export_enum("X", "Y") var axis: String

var boundaries: Array[float] = [0, 0]
var width: float
var direction: int = 1

func _ready() -> void:
	assert(axis != "", "Axis must be set!")
	
	boundaries[0] = $StartPosition.global_position[0 if axis == "X" else 1]
	boundaries[1] = $EndPosition.global_position[0 if axis == "X" else 1]
	
	width = $MovingPlatformSprite.region_rect.size.x

func _physics_process(_delta: float) -> void:
	velocity[0 if axis == "X" else 1] = direction * speed
	
	if (axis == "X" and (global_position.x < boundaries[0] and direction == -1 or global_position.x > boundaries[1] - width and direction == 1)) or \
	   (axis == "Y" and (global_position.y > boundaries[0] and direction == 1 or global_position.y < boundaries[1] and direction == -1)):
		direction *= -1
	
	move_and_slide()
