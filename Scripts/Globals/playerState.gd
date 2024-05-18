# PlayerState.gd
class_name PlayerState
extends  Node

@export
var animation_name: String

@export
var state_id: int

# Hold a referance to the parent so that it can be controlled by the state
var parent: Player

func enter() -> void:
	parent.animations.queue(animation_name)
	parent.label.text = animation_name

func exit() -> void:
	parent.animations.stop()
	parent.animations.clear_queue()

func process_physics(delta: float) -> PlayerState:
	return null

func process_frame(delta: float) -> PlayerState:
	return null

func process_input(event: InputEvent) -> PlayerState:
	return null
