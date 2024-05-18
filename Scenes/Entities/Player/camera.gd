class_name Camera
extends Camera2D

enum CAMERA_STATES
{
	Fixed,		#0
	Follow_Ahead,		#1
	Follow_Smooth,		#2
}
@onready
var camera_state: int
@onready
var camera_prev_state: int

@onready
var stateManager = $CameraStateManager
@onready
var player = $".."

func _ready():
	# Initialize the state manager, passing a referance of the player to the states
	# That way they can move and react accordingly
	stateManager.init(self, player)

func _unhandled_input(event: InputEvent) -> void:
	stateManager.process_input(event)

func _physics_process(delta: float) -> void:
	stateManager.process_physics(delta)

func _process(delta: float) -> void:
	stateManager.process_frame(delta)



	## Follow ahead
	#if parent.velocity.x >= 0 and not is_wall_hit:
		#position.x = (parent.velocity.x * parent.velocity.x) / (360 * 18)
	#else:
		#position.x = -(parent.velocity.x * parent.velocity.x) / (360 * 18)
	
	#lerp()
	#position.x = 20 * sin(parent.velocity.x / 229.2)
	#print(position)

