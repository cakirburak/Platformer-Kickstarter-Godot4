# playerStateManager.gd
extends Node

@export
var init_state: CameraState
var current_state: CameraState

var parent: Camera
var player: Player
# Initialize the state manager by giving each child state a referance to the
# parent object it belongs to and enter the default init_state.
func init(camera: Camera, playerr: Player) -> void:
	for child in get_children():
		child.parent = camera
		child.player = playerr
	self.parent = camera
	# Initialize to the default state
	change_state(init_state)
	print("INFO: CameraStateManager initialized")

# Change to the new state by first calling any exit logic on the current state
func change_state(new_state: CameraState) -> void:
	if current_state:
		parent.camera_prev_state = current_state.state_id
		current_state.exit()
	
	parent.camera_state = new_state.state_id
	current_state = new_state
	current_state.enter()

# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if(new_state):
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
