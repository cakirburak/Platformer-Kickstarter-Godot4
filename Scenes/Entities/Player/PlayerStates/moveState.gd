# MoveState.gd
extends PlayerState

@export
var fall_state: PlayerState
@export
var idle_state: PlayerState
@export
var jump_state: PlayerState
@export
var push_state: PlayerState

@onready
var current_dir: int
@onready
var prev_dir: int

func enter() -> void:
	if parent.player_prev_state == parent.PLAYER_STATES.Idle:
		parent.animations.queue("Idle_to_Move")
	
	current_dir = 0
	prev_dir = 0
	super()

func process_physics(delta: float) -> PlayerState:
	parent.velocity.y += parent.fall_gravity * delta
	prev_dir = current_dir
	
	var movement = Input.get_axis('move_l', 'move_r')
	
	if movement == 0 and parent.velocity.x == 0:
		return idle_state
	
	if not parent.is_on_floor():
		parent.coyoteTimer.start(parent.coyote_time)
		parent.can_jump = true
		return fall_state
	
	if movement != 0:
		parent.sprite.flip_h = movement < 0
	
	parent.velocity.x = move_toward(parent.velocity.x, parent.move_speed * movement, parent.acceleration)
	parent.move_and_slide()
	
	if parent.is_onWall and parent.velocity.x == 0:
		parent.onWall_dir = movement
		return idle_state
		#return push_state
	
	return null

func process_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed('jump') and parent.is_on_floor():
		return jump_state
	
	return null
