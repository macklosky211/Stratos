extends State

const DURATION = .1

var vault_speed_boost : float = 1.5

var initial_velocity : Vector3
var tween : Tween

@onready var landing: RayCast3D = $"Landing"
@onready var bottom_collision: ShapeCast3D = $"../../Bottom_Collision"


func _enter(player : State_Controller) -> void:
	player.should_gravity = false
	initial_velocity = player.velocity
	# player.velocity = Vector3.ZERO
	
	if tween: tween.kill()
	
	var bottom_point : Vector3 = bottom_collision.get_collision_point(floori(bottom_collision.collision_result.size() / 2))
	
	landing.global_position = (bottom_point - bottom_collision.global_position) * 1.01 + bottom_point
	landing.global_position.y = player.global_position.y + 2.0

	landing.force_raycast_update()

	tween = create_tween()
	tween.tween_property(player, "global_position", landing.get_collision_point() + Vector3(0,1,0), DURATION).from_current()
	tween.tween_callback(func() -> void: player.current_state = player.Sprinting)

func _exit(player : State_Controller) -> void:
	var speed_boost : Vector3 = initial_velocity
	speed_boost.y = 0.0
	speed_boost = speed_boost.normalized() * vault_speed_boost
	player.velocity = initial_velocity + speed_boost
	player.should_gravity = true
