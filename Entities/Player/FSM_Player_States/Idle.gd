extends State

func _update(player : State_Controller, _delta : float) -> void:
	if Input.is_action_pressed("Crouch"): player.current_state = player.Crouching; return
	elif _get_input() or Input.is_action_pressed("Jump"):
		if Input.is_action_pressed("Sprint"): player.current_state = player.Sprinting; return
		else: player.current_state = player.Walking; return
	else: player.velocity = _move_vector_towards2(player.velocity, Vector3.ZERO, player.ACCEL)

func _get_state_name() -> String:
	return "Player_Idle"
