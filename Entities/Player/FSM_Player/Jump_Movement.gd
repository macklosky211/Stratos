extends State
class_name Jumping

var speed : float = 0.0

func _enter(player : State_Controller) -> void:
	speed = Vector2(player.velocity.x, player.velocity.z).length() - 2.0
	speed = maxf(speed, 2.0)

func _update(player : State_Controller, _delta : float) -> void:
	if player.is_on_floor(): player.current_state = player.Idle; return
	
	player.is_crouching = Input.is_action_pressed("Crouch")
	
	var input : Vector2 = _get_input()
	var direction : Vector3 = player._get_world_direction_from_input(input)

	player.velocity = _move_vector_towards2(player.velocity, direction * speed, player.AIR_ACCEL)


func _get_state_name() -> String:
	return "Player_Air_Movement"
