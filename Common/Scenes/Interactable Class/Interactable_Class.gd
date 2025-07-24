class_name Interactable extends Node

func _ready() -> void:
	add_to_group("Interactable")

func interact(_player : Player) -> void:
	pass
