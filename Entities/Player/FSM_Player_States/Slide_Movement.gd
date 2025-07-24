extends State

const slide_decel : float = 0.05
const min_slide_speed : float = 1.0

var velocity_last_frame : float = 0.0

func _enter(player : State_Controller) -> void:
	player.is_crouching = true

func _exit(player : State_Controller) -> void:
	player.is_crouching = false

func _update(player : State_Controller, _delta : float) -> void:
	if Input.is_action_pressed("Jump") and player._try_vault(): player.current_state = player.vaulting; return
	elif Input.is_action_pressed("Jump") and player.is_on_floor(): 
		player.velocity += player.transform.basis * Vector3(0.0, 0.0, -5.0)
		player.velocity.y += player.JUMP_VELOCITY * 1.25
	elif not Input.is_action_pressed("Crouch"): player.current_state = player.Sprinting; return
	
	var current_speed : float = absf(player.velocity.length()) 
	
	if current_speed < min_slide_speed: player.current_state = player.Crouching
	
	var input : Vector2 = _get_input()
	
	var direction : Vector3 = player._get_world_direction_from_input(input)
	
	if current_speed <= velocity_last_frame: 
		var horizontal_velocity = player.velocity
		horizontal_velocity.y = 0.0
		direction *= horizontal_velocity.length()
		direction.y = player.velocity.y
		player.velocity = _move_vector_towards2(direction, Vector3.ZERO, slide_decel)
		
	else: player.velocity = _move_vector_towards2(player.velocity, direction * player.SPRINT_SPEED, player.ACCEL)
	velocity_last_frame = current_speed


func _get_state_name() -> String:
	return "Player_Slide_Movement"
