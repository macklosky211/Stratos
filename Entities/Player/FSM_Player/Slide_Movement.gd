extends State
class_name Sliding

@export var Slide_Curve: Curve
const MAX_SLIDE_TIME : float = 3

const FORWARD_SPEED : float = 10.0
const BACKWARD_SPEED : float = FORWARD_SPEED * 0.5
const STRAFE_SPEED : float = FORWARD_SPEED * 0.75
const DIAGNAL_SPEED : float = (FORWARD_SPEED + STRAFE_SPEED) * 0.5

const SPEEDS   : Array[float] = [0, FORWARD_SPEED,   BACKWARD_SPEED,   STRAFE_SPEED,   DIAGNAL_SPEED  ]

var slide_time : float = 0.0
var exit_time : float = 0


func _enter(_player : State_Controller) -> void:
	var current_time : float = Time.get_ticks_msec() / 1000.0
	slide_time = clampf(slide_time - (current_time - exit_time), 0.0, MAX_SLIDE_TIME)

func _exit(_player: State_Controller) -> void:
	exit_time = Time.get_ticks_msec() / 1000.0


func _update(player : State_Controller, delta : float) -> void:
	if Input.is_action_pressed("Jump") and player.velocity.y < player.JUMP_VELOCITY: player.velocity.y += player.JUMP_VELOCITY
	if not player.is_on_floor(): player.current_state = player.Jumping; return
	
	elif not Input.is_action_pressed("Crouch"): player.current_state = player.Walking; return
	
	slide_time = clampf(slide_time + delta, 0.0, MAX_SLIDE_TIME)
	
	var input : Vector2 = _get_input()
	
	if not input: player.current_state = player.Idle; return
	
	var direction : Vector3 = player._get_world_direction_from_input(input)
	
	var speed_index : int = 0 # Default to '0' AKA no speed.
	if input.x != 0: # If were holding left/right we are either strafing or moving diagnal.
		speed_index = 3 # STRAFE_SPEED
		speed_index += int(absf(input.y)) # Move towards Diagnal
	elif input.y > 0: speed_index = 1 # If not strafing were either going forwards 
	elif input.y < 0: speed_index = 2 # or backwards.

	var speed_mult : float = Slide_Curve.sample(slide_time / MAX_SLIDE_TIME)

	player.velocity = _move_vector_towards2(player.velocity, direction * SPEEDS[speed_index] * speed_mult, player.GROUNDED_ACCEL)


func _get_state_name() -> String:
	return "Player_Sprint_Movement"
