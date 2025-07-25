class_name Dropped_Weapon extends Interactable

@export var weapon_scene : PackedScene

func _ready() -> void:
	assert(weapon_scene, "Weapon Resource must not be null.")

func interact(_player : Player) -> void:
	pass
