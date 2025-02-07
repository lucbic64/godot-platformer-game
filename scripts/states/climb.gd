class_name Climb
extends State

@export var idle_state: State
@export var fall_state: State
@export var run_state: State

func process_physics(delta: float) -> State:
	if Input.is_action_pressed("jump"):
		parent.velocity.y = -25
	else:
		parent.velocity.y = 25
	
	var direction := Input.get_axis("left", "right")
	
	if direction:
		parent.player_sprite.flip_h = direction < 0
		
		if parent.is_on_floor():
			parent.velocity.x = move_toward(
				parent.velocity.x,
				parent.player_movement.max_speed * direction,
				parent.player_movement.acceleration * delta
			)
		else:
			parent.velocity.x = parent.player_movement.max_speed * 0.25 * direction
	else:
		if parent.is_on_floor():
			parent.velocity.x = lerp(
				parent.velocity.x,
				0.0,
				(parent.player_movement.friction if parent.is_on_floor() else parent.player_movement.air_friction) * delta
			)
		else:
			parent.velocity.x = 0
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> State:
	if parent.ladder_detection.has_overlapping_areas():
		return null
	
	if parent.is_on_floor():
		if Input.get_axis("left", "right"):
			return run_state
		return idle_state
	else:
		return fall_state
