# PlayerState.gd
class_name CameraState
extends  Node

@export
var state_id: int

# Hold a referance to the parent so that it can be controlled by the state
var parent: Camera
var player: Player

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_physics(delta: float) -> CameraState:
	return null

func process_frame(delta: float) -> CameraState:
	return null

func process_input(event: InputEvent) -> CameraState:
	return null
