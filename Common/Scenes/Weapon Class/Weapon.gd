class_name Weapon extends Node3D

@onready var muzzle: Marker3D = $Muzzle

## Important, this is the key used to find which weapon to spawn when dropping the weapon.
@export var weapon_name : String

@export var bullet_speed : float = 100.0

@export var is_two_handed : bool = true

func _ready() -> void:
	assert(weapon_name, "weapon name must not be null.")
	if not is_multiplayer_authority(): process_mode = Node.PROCESS_MODE_DISABLED

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fire"):
		var spawn_position : Vector3 = muzzle.global_position
		var spawn_rotation : Vector3 = muzzle.global_rotation
		var spawn_velocity : Vector3 = -muzzle.global_transform.basis.z * bullet_speed
		spawn_bullet.rpc_id(1, [spawn_position, spawn_rotation, spawn_velocity])

@rpc("any_peer", "call_local")
func spawn_bullet(vars : Array) -> void:
	if not multiplayer.is_server(): push_error("Attempting to spawn bullet from client that is not the server."); return
	
	get_tree().current_scene.bullet_spawner.spawn(vars)
