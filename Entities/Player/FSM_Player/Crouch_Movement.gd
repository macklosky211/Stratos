extends State
class_name Crouching

const FORWARD_SPEED : float = 2.5
const BACKWARD_SPEED : float = FORWARD_SPEED * 0.5
const STRAFE_SPEED : float = FORWARD_SPEED * 0.75
const DIAGNAL_SPEED : float = (FORWARD_SPEED + STRAFE_SPEED) * 0.5

const SPEEDS : Array[float] = [0, FORWARD_SPEED, BACKWARD_SPEED, STRAFE_SPEED, DIAGNAL_SPEED]

func _enter(player : State_Controller) -> void:
	player.is_crouching = true

func _exit(player : State_Controller) -> void:
	player.is_crouching = Input.is_action_pressed("Crouch")

func _update(player : State_Controller, _delta : float) -> void:
	if not player.is_on_floor(): player.current_state = player.Air_Movement; return
	if not Input.is_action_pressed("Crouch"): player.current_state = player.Idle; return
	
	var input : Vector2 = _get_input()
	var direction : Vector3 = player._get_world_direction_from_input(input)
	
	var speed_index : int = 0 # Default to '0' AKA no speed.
	if input.x != 0: # If were holding left/right we are either strafing or moving diagnal.
		speed_index = 3 # STRAFE_SPEED
		speed_index += int(absf(input.y)) # Move towards Diagnal
	elif input.y > 0: speed_index = 1 # If not strafing were either going forwards 
	elif input.y < 0: speed_index = 2 # or backwards.

	player.velocity = _move_vector_towards2(player.velocity, direction * SPEEDS[speed_index], player.GROUNDED_ACCEL)


func _get_state_name() -> String:
	return "Player_Crouch_Movement"
