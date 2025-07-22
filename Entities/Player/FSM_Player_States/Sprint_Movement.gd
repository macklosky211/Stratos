extends State

func _update(player : State_Controller, _delta : float) -> void:
	if Input.is_action_pressed("Jump") and player._try_vault(): player.current_state = player.vaulting; return
	elif Input.is_action_pressed("Jump") and player.is_on_floor(): player.velocity.y += player.JUMP_VELOCITY
	if Input.is_action_pressed("Crouch"): player.current_state = player.Sliding; return
	elif not Input.is_action_pressed("Sprint"): player.current_state = player.Walking; return
	
	
	var input : Vector2 = _get_input()
	
	if not input: player.current_state = player.Idle; return
	
	var direction : Vector3 = player._get_world_direction_from_input(input)
	
	player.velocity = _move_vector_towards2(player.velocity, direction * player.SPRINT_SPEED, player.ACCEL)


func _get_state_name() -> String:
	return "Player_Sprint_Movement"
