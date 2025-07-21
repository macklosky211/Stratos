class_name Gun extends Node3D

@onready var muzzle: Marker3D = $Muzzle
@onready var muzzle_direction: Marker3D = $Muzzle_Direction

var bullet : PackedScene = preload("res://Entities/Bullet/bullet.tscn")

var BULLET_SPEED : float = 100.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fire"):
		var new_bullet:Bullet = bullet.instantiate()
		new_bullet.position = muzzle.global_position
		new_bullet.rotation = muzzle.global_rotation
		new_bullet.linear_velocity = ((muzzle_direction.global_position - new_bullet.position).normalized() * BULLET_SPEED)
		
		get_tree().current_scene.bullet_folder.add_child(new_bullet, true)
