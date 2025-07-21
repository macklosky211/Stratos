class_name HealthComponent extends Node

@export var MAX_HP : float = 100.0

var current_health : float = 100.0

func _ready() -> void:
	Event.Player_Events.player_died.connect(func(playerID : int) -> void: print("[%d] player died: %d" % [multiplayer.get_unique_id(), playerID])) 

@rpc("authority", "call_local")
func take_damage(amount : float) -> void:
	current_health -= amount
	if is_dead() and is_multiplayer_authority():
		Event.broadcast_event.rpc(Event.Player_Events.player_died, [get_multiplayer_authority()])

func is_dead() -> bool:
	return current_health <= 0.0

func reset() -> void:
	current_health = MAX_HP
