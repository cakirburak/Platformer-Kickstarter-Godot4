# JumpState.gd
extends PlayerState

@export
var fall_state: PlayerState
@export
var idle_state: PlayerState
@export
var move_state: PlayerState
@export
var double_jump_state: PlayerState

func enter() -> void:
	super()
	parent.is_double_jump_available = true
	parent.velocity.y = parent.jump_velocity

func process_physics(delta: float) -> PlayerState:
	parent.velocity.y += parent.jump_gravity * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	var movement = Input.get_axis('move_l', 'move_r')
	
	if movement != 0:
		parent.sprite.flip_h = movement < 0
	# NOTE: Is player needs momentum for max jump distance?
	#		If not just set constant velocity so that;
	#		every jump can acheive max distance no mather what horizontal momentum is.
	#		Keep in mind if you set constent velocity it will 
	parent.velocity.x = move_toward(parent.velocity.x, parent.move_speed * movement, parent.acceleration)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	
	return null

func process_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("double_jump"):
		return double_jump_state
	
	if event.is_action_released("jump") and parent.velocity.y < 0:
		return fall_state
	
	return null
