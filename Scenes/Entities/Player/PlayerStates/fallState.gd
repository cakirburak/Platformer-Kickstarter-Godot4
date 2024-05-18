# FallState.gd
extends PlayerState

#@export
#var air_jump_state: PlayerState
@export
var idle_state: PlayerState
@export
var move_state: PlayerState
@export
var jump_state: PlayerState
@export
var double_jump_state: PlayerState

func enter() -> void:
	super()

func process_physics(delta: float) -> PlayerState:
	if parent.velocity.y < parent.max_fall_gravity:
		parent.velocity.y += parent.fall_gravity * delta
	
	var movement = Input.get_axis('move_l', 'move_r')
	
	if movement != 0:
		parent.sprite.flip_h = movement < 0
	
	parent.velocity.x = move_toward(parent.velocity.x, parent.move_speed * movement, parent.acceleration)
	parent.move_and_slide()

	if parent.is_on_floor():
		parent.is_double_jump_available = true
		if parent.jump_buffer:
			return jump_state
		elif movement != 0:
			return move_state
		
		return idle_state
	
	return null

func process_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("jump"):
		if parent.can_jump:
			return jump_state
		parent.jumpBufferTimer.start(parent.jump_buffer_time)
		parent.jump_buffer = true
	elif event.is_action_pressed('double_jump') and parent.is_double_jump_available:
		return double_jump_state
	
	return null

func _on_coyote_timer_timeout():
	parent.can_jump = false

func _on_jump_buffer_timer_timeout():
	parent.jump_buffer = false
