class_name WeaponManagerClass extends Node3D

class WeaponTemplate:
	var scene_path : String = ""
	var spawner_index : int = -1
	
	func _init(_scene_path : String = "", _spawner_index : int = -1) -> void:
		scene_path = _scene_path
		spawner_index = _spawner_index

var weapon_list : Dictionary[StringName, WeaponTemplate] = {
	"Assult_Rifle" : WeaponTemplate.new("res://Entities/Weapons/Assult Rifle/AR_Weapon.tscn")
}

enum HAND {LEFT, RIGHT}

@onready var equiped_gun_spawner: MultiplayerSpawner = $EquipedGunSpawner
@onready var left_position: Vector3 = $LeftPosition.position
@onready var right_position: Vector3 = $RightPosition.position

@onready var equiped_weapons : Dictionary[HAND, Weapon] = {HAND.LEFT : null, HAND.RIGHT : null}

func _ready() -> void:
	equiped_gun_spawner.spawn_function = gun_spawn_function
	
	## Fills weapon spawner with weapons defined in {weapon_list}, and maps their indexes for future reference.
	for weapon : WeaponTemplate in weapon_list.values():
		equiped_gun_spawner.add_spawnable_scene(weapon.scene_path)
		weapon.spawner_index = equiped_gun_spawner.get_spawnable_scene_count() - 1

func drop_weapon(hand : HAND = HAND.LEFT) -> void:
	if equiped_weapons[hand] != null:
		request_spawn_dropped_weapon.rpc_id(1, ["Assult Rifle", global_position, -global_transform.basis.z])
		
		equiped_weapons[hand].queue_free() # Erase the weapon from our hands.
		equiped_weapons[hand] = null # Just in case.

func unequip_weapon() -> void:
	if equiped_weapons[HAND.LEFT]:
		drop_weapon()
	else:
		drop_weapon(HAND.RIGHT)

@rpc("any_peer", "call_local")
func request_spawn_dropped_weapon(vars : Array) -> void:
	if not multiplayer.is_server(): return
	
	get_tree().current_scene.dropped_weapons_spawner.spawn(vars)

func equip_weapon(weapon_node : Weapon) -> void:
	weapon_node.reparent(self, false)
	
	if weapon_node.is_two_handed:
		drop_weapon(HAND.LEFT)
		drop_weapon(HAND.RIGHT)

@rpc("any_peer", "call_local")
func request_spawn_equiped_weapon(vars : Array) -> void:
	if not multiplayer.is_server(): return
	equiped_gun_spawner.spawn(vars)

func gun_spawn_function(vars : Array) -> Node:
	print("[%d] Gun_Spawn_Function was called" % multiplayer.get_unique_id())
	var weapon_key : StringName = vars[0]
	
	var weapon_template : WeaponTemplate = weapon_list.get(weapon_key)
	assert(weapon_template != null, "Weapon Template was null. the key didnt match anything in the {weapon_list}")
	
	var weapon_scene : PackedScene = load(equiped_gun_spawner.get_spawnable_scene(weapon_template.spawner_index))
	
	var new_weapon : Weapon = weapon_scene.instantiate()
	
	if new_weapon.is_two_handed:
		drop_weapon(HAND.LEFT)
		drop_weapon(HAND.RIGHT)
		new_weapon.position = right_position
		equiped_weapons[HAND.RIGHT] = new_weapon
	elif equiped_weapons[HAND.RIGHT] == null:
		new_weapon.position = right_position
		equiped_weapons[HAND.RIGHT] = new_weapon
	else:
		drop_weapon(HAND.LEFT)
		new_weapon.position = left_position
		equiped_weapons[HAND.LEFT] = new_weapon
	
	print(equiped_weapons)
	return new_weapon
