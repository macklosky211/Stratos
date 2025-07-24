extends State

const DURATION = .25

var vault_speed_boost : float = 1.5


var initial_speed : float = 0.0
var tween : Tween

@onready var landing: RayCast3D = $"Landing"
@onready var bottom_collision: ShapeCast3D = $"../../Bottom_Collision"

var apply_speed_boost : bool = true

func _enter(player : State_Controller) -> void:
	apply_speed_boost = true
	player.should_gravity = false
	var initial_velocity : Vector3 = player.velocity
	initial_velocity.y = 0.0
	initial_speed = initial_velocity.length()
	# player.velocity = Vector3.ZERO
	
	if tween: tween.kill()
	
	var middle_index = floori(bottom_collision.collision_result.size() / 2.0)
	
	var bottom_point : Vector3 = bottom_collision.get_collision_point(middle_index)
	
	landing.global_position = (bottom_point - bottom_collision.global_position) * 1.01 + bottom_point
	landing.global_position.y = player.global_position.y + 2.0
	
	landing.force_raycast_update()
	
	var vault_position : Vector3 = landing.get_collision_point()
	
	if vault_position.distance_to(player.global_position) > 2.0: # I wish labels were a thing, cause then i would just adjust the funny magic number above...
		# Instead im just gonna force this vault to fail.
		#print("failed to vault, was trying to vault to a position very far away (%d)" % vault_position.distance_to(player.global_position))
		apply_speed_boost = false
		player.current_state = player.Idle
		return
	
	vault_position += Vector3(0,1,0)
	
	tween = create_tween()
	tween.tween_property(player, "global_position", vault_position, DURATION).from_current()
	tween.tween_callback(func() -> void: player.current_state = player.Sprinting)

func _exit(player : State_Controller) -> void:
	if apply_speed_boost:
		var speed_boost : float = initial_speed + vault_speed_boost
		player.velocity = player.velocity.normalized() * speed_boost
	player.should_gravity = true

func _get_state_name() -> String:
	return "Player_Vault_Movement"
