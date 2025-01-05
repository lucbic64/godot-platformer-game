extends CharacterBody2D

@export var max_speed: float = 200.0
@export var acceleration = 50.0
@export var friction_percentage = .2
@export var air_friction_percentage = .05

@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float

@onready var jump_velocity = (2.0 * jump_height) / jump_time_to_peak * -1.0
@onready var jump_gravity = (2.0 * jump_height) / jump_time_to_peak ** 2
@onready var fall_gravity = (2.0 * jump_height) / jump_time_to_descent ** 2

var gravity: float:
	get():
		return jump_gravity if velocity.y < 0 else fall_gravity

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = move_toward(velocity.x, max_speed * direction, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, (friction_percentage if is_on_floor() else air_friction_percentage) * delta)

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
	
	move_and_slide()
