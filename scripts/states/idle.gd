extends State

@export var fall_state: State
@export var jump_state: State
@export var run_state: State

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	elif Input.get_axis("left", "right"):
		return run_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.player_movement.fall_gravity * delta
	
	if parent.velocity.x:
		parent.velocity.x = lerp(
			parent.velocity.x,
			0.0,
			(parent.player_movement.friction if parent.is_on_floor() else parent.player_movement.air_friction) * delta
		)
	
	parent.move_and_slide()
	
	if not parent.is_on_floor():
		return fall_state
	
	return null