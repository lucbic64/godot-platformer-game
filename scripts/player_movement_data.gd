class_name PlayerMovementData
extends Resource

@export_group("Movement")
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var max_speed: float = 200
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s²") var acceleration: float = 50
## High value due to faulty implementation of delta within lerp function
@export_custom(PROPERTY_HINT_NONE, "suffix:%") var friction: float = 2000:
	get(): return friction / 100
## High value due to faulty implementation of delta within lerp function
@export_custom(PROPERTY_HINT_NONE, "suffix:%") var air_friction: float = 500:
	get(): return air_friction / 100

@export_group("Jump")
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var jump_height: float = 100
## The time in seconds for the character to reach the jump's peak after the jump button was pressed 
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var jump_peak: float = 0.5
## The time in seconds for the character to land on the ground after the peak of the jump was reached
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var jump_descent: float = 0.5

@export_group("Climb")
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var climb_speed: float = 25
@export_custom(PROPERTY_HINT_NONE, "suffix:%") var movement_reduction: float = 25:
	get(): return movement_reduction / 100

var jump_velocity: float
var jump_gravity: float
var fall_gravity: float

func calc_jump_values() -> void:
	jump_velocity = (2.0 * jump_height) / jump_peak * -1.0
	jump_gravity = (2.0 * jump_height) / jump_peak ** 2
	fall_gravity = (2.0 * jump_height) / jump_descent ** 2
