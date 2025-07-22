extends State

const slide_decel : float = 0.1

var velocity_last_frame : float = 0.0

func _update(player : State_Controller, delta : float) -> void:
	if Input.is_action_pressed("Jump") and player.is_on_floor(): 
		player.velocity += player.transform.basis * Vector3(0.0, 0.0, -5.0)
		player.velocity.y += player.JUMP_VELOCITY * 1.25
	elif not Input.is_action_pressed("Crouch"): player.current_state = player.Sprinting; return
	
	if not player.is_on_floor(): return
	
	var current_speed : float = absf(player.velocity.length()) 
	
	
	var input : Vector2 = _get_input()
	
	if not input: player.current_state = player.Idle; return
	
	var direction : Vector3 = player._get_world_direction_from_input(input)
	
	if current_speed < velocity_last_frame:
		print("no good, were deceling")
		player.velocity = _move_vector_towards2(player.velocity, Vector3.ZERO, slide_decel)
	else:
		print("were accelerating")
		player.velocity = _move_vector_towards2(player.velocity, direction * player.SPRINT_SPEED, player.ACCEL)
	
	#velocity_last_frame = absf(player.velocity.length())
	velocity_last_frame = current_speed


func _get_state_name() -> String:
	return "Player_Slide_Movement"
