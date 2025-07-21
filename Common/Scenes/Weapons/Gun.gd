class_name Gun extends Node3D

var BULLET_SPEED:float = 100
var bullet:PackedScene = preload("res://Entities/Bullet/bullet.tscn")
@onready var muzzle: Marker3D = $Muzzle
@onready var muzzle_direction: Marker3D = $Muzzle_Direction


func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fire"):
		var new_bullet:Bullet = bullet.instantiate()
		new_bullet.position = muzzle.global_position
		#new_bullet.look_at(muzzle_direction.global_position)
		new_bullet.rotation = muzzle.global_rotation
		new_bullet.linear_velocity = ((muzzle_direction.global_position - new_bullet.position).normalized() * BULLET_SPEED)
		get_tree().current_scene.add_child(new_bullet, true)
		
		
