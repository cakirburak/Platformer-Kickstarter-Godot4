# fixedState.gd
extends CameraState

func enter() -> void:
	super()
	parent.position.x = 0

func process_physics(delta: float) -> CameraState:
	return null
