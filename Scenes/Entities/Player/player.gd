# player.gd
class_name Player
extends CharacterBody2D

enum PLAYER_STATES
{
	Idle,		#0
	Move,		#1
	Fall,		#2
	Jump,		#3
	Double_Jump,#4
	Push		#5
}
@onready
var player_state: int
@onready
var player_prev_state: int

@onready
var animations = $PlayerAnimations
@onready
var label = $Label
@onready
var sprite = $PlayerSprite2D
@onready
var wallCollisionArea = $WallCollisionArea
@onready
var stateManager = $PlayerStateManager
@onready
var coyoteTimer = $Timers/CoyoteTimer
@onready
var jumpBufferTimer = $Timers/JumpBufferTimer
@onready
var camera = $Camera

@export
var move_speed: float = 360
@export
var acceleration: float = 40

@onready # for handling coyote time feature
var can_jump: bool = false
@onready # for handling jump input buffering
var jump_buffer: bool = false

@export
var jump_height: float = 80
@export
var jump_time_to_peak: float = 0.4
@export
var jump_time_to_descent: float = 0.3
@export
var coyote_time: float = 0.08
@export
var jump_buffer_time: float = 0.1

@onready
var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready
var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready
var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export
var double_jump_height: float = 60
@export
var double_jump_time_to_peak: float = 0.4

@onready
var is_double_jump_available: bool

@onready
var double_jump_velocity: float = ((2.0 * double_jump_height) / double_jump_time_to_peak) * -1.0
@onready
var double_jump_gravity: float = ((-2.0 * double_jump_height) / (double_jump_time_to_peak * jump_time_to_peak)) * -1.0

@export
var max_fall_gravity: float = 560

@onready
var is_onWall: bool
@onready
var onWall_dir: int

func _ready():
	# Initialize the state manager, passing a referance of the player to the states
	# That way they can move and react accordingly
	stateManager.init(self)

func _unhandled_input(event: InputEvent) -> void:
	stateManager.process_input(event)

func _physics_process(delta: float) -> void:
	stateManager.process_physics(delta)

func _process(delta: float) -> void:
	stateManager.process_frame(delta)

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _on_wall_collision_area_body_entered(body):
	is_onWall = true

func _on_wall_collision_area_body_exited(body):
	is_onWall = false
