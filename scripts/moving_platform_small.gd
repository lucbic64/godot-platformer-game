extends CharacterBody2D

@export var speed = 100
@export_enum("X", "Y") var axis: String
@onready var start_pos = $StartPosition
@onready var end_pos = $EndPosition
var boundaries = [0, 0]
var direction = 1

func _ready() -> void:
	boundaries[0] = start_pos.global_position[0 if axis == "X" else 1]
	boundaries[1] = end_pos.global_position[0 if axis == "X" else 1]
	
func _physics_process(_delta: float) -> void:
	assert(axis != "", "Axis must be set!")
	velocity[0 if axis == "X" else 1] = direction * speed
	if (axis == "X" and (global_position.x < boundaries[0] and direction == -1 or global_position.x > boundaries[1] - 16 and direction == 1)) or \
	   (axis == "Y" and (global_position.y > boundaries[0] and direction == 1 or global_position.y < boundaries[1] and direction == -1)):
		direction *= -1
	
	move_and_slide()
