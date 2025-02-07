class_name Run
extends State

@export var idle_state: State
@export var fall_state: State
@export var jump_state: State
@export var climb_state: State

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.player_movement.fall_gravity * delta
	
	var direction := Input.get_axis("left", "right")
	
	if direction:
		parent.player_sprite.flip_h = direction < 0
		
		parent.velocity.x = move_toward(
			parent.velocity.x,
			parent.player_movement.max_speed * direction,
			parent.player_movement.acceleration * delta
		)
	else:
		parent.move_and_slide()
		return idle_state
	
	parent.move_and_slide()
	
	if not parent.is_on_floor():
		return fall_state
	
	return null

func process_frame(_delta: float) -> State:
	if parent.ladder_detection.has_overlapping_areas():
		return climb_state
	
	return null
