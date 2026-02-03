class_name Bullet extends RigidBody3D

@export var sync_time : float = 0.5

var despawn_timer : float = 10.0
var sync_timer : float = sync_time
var damage : float = 10.0

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	despawn_timer -= delta
	if despawn_timer <= 0: queue_free()
	
	sync_timer -= delta
	if sync_timer <= 0:
		sync_timer = sync_time
		sync_position.rpc(global_position, linear_velocity)


@rpc("authority")
func sync_position(passed_position : Vector3, velocity : Vector3) -> void:
	#print("[%d] sync_position was called by [%d]" % [multiplayer.get_unique_id(), multiplayer.get_remote_sender_id()])
	global_position = passed_position
	linear_velocity = velocity


func _on_body_hit(body: Node) -> void:
	if not multiplayer.is_server(): return
	if body is Player:
		body.health.take_damage.rpc_id(body.get_multiplayer_authority(), damage)
		print("[%d] called body_hit, body that was hit: (%s, %d)" % [multiplayer.get_unique_id(), body.name, body.get_multiplayer_authority()])
		if multiplayer.is_server(): queue_free()
