extends State

const slide_decel : float = 0.1

var velocity_last_frame : float = 0.0

func _update(player : State_Controller, delta : float) -> void:
	if Input.is_action_pressed("Jump") and player.velocity.y < player.JUMP_VELOCITY: player.velocity.y += player.JUMP_VELOCITY
	if not player.is_on_floor(): player.current_state = player.Jumping; return
	elif not Input.is_action_pressed("Crouch"): player.current_state = player.Walking; return
	
	var input : Vector2 = _get_input()
	
	if not input: player.current_state = player.Idle; return
	
	var direction : Vector3 = player._get_world_direction_from_input(input)
	
	if absf(player.velocity.length()) <= velocity_last_frame:
		player.velocity = _move_vector_towards2(player.velocity, Vector3.ZERO, slide_decel)
	else:
		player.velocity = _move_vector_towards2(player.velocity, direction * player.SPRINT_SPEED, player.ACCEL)
	
	velocity_last_frame = absf(player.velocity.length())


func _get_state_name() -> String:
	return "Player_Slide_Movement"
