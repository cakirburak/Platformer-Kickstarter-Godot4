# JumpState.gd
extends PlayerState

@export
var fall_state: PlayerState
@export
var idle_state: PlayerState
@export
var move_state: PlayerState

func enter() -> void:
	super()
	parent.is_double_jump_available = false
	parent.velocity.y = parent.double_jump_velocity

func process_physics(delta: float) -> PlayerState:
	parent.velocity.y += parent.double_jump_gravity * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	var movement = Input.get_axis('move_l', 'move_r')
	
	if movement != 0:
		parent.sprite.flip_h = movement < 0
	
	parent.velocity.x = move_toward(parent.velocity.x, parent.move_speed * movement, parent.acceleration)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null
