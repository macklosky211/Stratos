extends MultiplayerSpawner

@export var spawnable_scenes : Dictionary[String, PackedScene]

func _ready() -> void:
	spawn_function = weapon_spawn_func
	for obj : PackedScene in spawnable_scenes.values():
		add_spawnable_scene(obj.resource_path)

func weapon_spawn_func(vars : Array) -> Node:
	var weapon_type : String = vars[0]
	var spawn_position : Vector3 = vars[1]
	var forward_dir : Vector3 = vars[2]
	
	var weapon_scene : RigidBody3D = spawnable_scenes[weapon_type].instantiate()
	weapon_scene.position = spawn_position
	weapon_scene.call_deferred("apply_central_force", forward_dir * 5.0)
	return weapon_scene
