extends State

@export var fall_state: State
@export var idle_state: State
@export var run_state: State

func enter() -> void:
	super()
	parent.velocity.y = parent.player_movement.jump_velocity

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.player_movement.jump_gravity * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	var direction := Input.get_axis("left", "right")
	
	if direction:
		parent.player_sprite.flip_h = direction < 0
		
		parent.velocity.x = move_toward(
			parent.velocity.x,
			parent.player_movement.max_speed * direction,
			parent.player_movement.acceleration * delta
		)
	else:
		parent.velocity.x = lerp(
			parent.velocity.x,
			0.0,
			(parent.player_movement.friction if parent.is_on_floor() else parent.player_movement.air_friction) * delta
		)
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if Input.get_axis("left", "right"):
			return run_state
		return idle_state
	
	return null
