class_name WeaponManagerClass extends Node3D

enum HAND {LEFT, RIGHT}

@onready var equiped_gun_spawner: MultiplayerSpawner = $EquipedGunSpawner
@onready var left_position: Vector3 = $LeftPosition.position
@onready var right_position: Vector3 = $RightPosition.position

@onready var equiped_weapons : Dictionary[HAND, Weapon] = {HAND.LEFT : null, HAND.RIGHT : null}

func _ready() -> void:
	equiped_gun_spawner.spawn_function = gun_spawn_function

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
	var weapon_scene : PackedScene = vars[0]
	
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
