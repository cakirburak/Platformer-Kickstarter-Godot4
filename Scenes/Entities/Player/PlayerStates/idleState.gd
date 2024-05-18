# IdleState.gd
extends PlayerState

@export
var fall_state: PlayerState
@export
var jump_state: PlayerState
@export
var move_state: PlayerState
@export
var push_state: PlayerState

func enter() -> void:
	parent.velocity.x = 0
	
	if parent.player_prev_state == parent.PLAYER_STATES.Move:
		parent.animations.queue("Move_to_Idle")
	
	super()

func process_physics(delta: float) -> PlayerState:
	parent.velocity.y += parent.fall_gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	
	return null

func process_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed('jump') and parent.is_on_floor():
		return jump_state
	if event.is_action_pressed('move_l') or event.is_action_pressed('move_r'):
		var movement = Input.get_axis('move_l', 'move_r')
		if parent.is_onWall and movement == parent.onWall_dir:
			return null
			#return push_state
		
		return move_state
	
	return null
