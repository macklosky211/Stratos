class_name Bullet extends RigidBody3D
var timer:float = 10

func _physics_process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		queue_free()
