extends State

func _enter(player : State_Controller) -> void:
	player.is_crouching = true

func _exit(player : State_Controller) -> void:
	player.is_crouching = false

func _update(player : State_Controller, _delta : float) -> void:
	if not player.is_on_floor(): player.current_state = player.Walking; return
	if Input.is_action_pressed("Jump") and player._try_vault(): player.current_state = player.vaulting; return
	elif Input.is_action_pressed("Jump") and player.is_on_floor(): player.velocity.y += player.JUMP_VELOCITY
	if not Input.is_action_pressed("Crouch"): player.current_state = player.Idle; return
	
	var input : Vector2 = _get_input()
	var direction : Vector3 = player._get_world_direction_from_input(input)

	player.velocity = _move_vector_towards2(player.velocity, direction * player.CROUCH_SPEED, player.ACCEL)


func _get_state_name() -> String:
	return "Player_Crouch_Movement"
