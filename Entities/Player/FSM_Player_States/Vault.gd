extends State

const DURATION = .1

var velocity : Vector3
var tween : Tween

@onready var landing: RayCast3D = $"../../Landing"
@onready var bottom_collision: RayCast3D = $"../../Bottom_Collision"

func _enter(player : State_Controller) -> void:
	player.should_gravity = false
	velocity = player.velocity
	player.velocity = Vector3.ZERO
	if tween: tween.kill()
	tween = create_tween()
	landing.global_position = bottom_collision.get_collision_point() + (bottom_collision.get_collision_point() - bottom_collision.global_position) * 1.1
	landing.global_position.y = player.global_position.y + 2
	landing.force_raycast_update()
	tween.tween_property(player, "global_position", landing.get_collision_point() + Vector3(0,1,0), DURATION)
	tween.tween_callback(func() -> void: player.velocity = velocity; player.current_state = player.Sprinting; player.should_gravity = true)
	print(player.global_position,landing.global_position, landing.get_collision_point())

#for testing purpose
func _update(player : State_Controller, delta:float) -> void:
	pass
