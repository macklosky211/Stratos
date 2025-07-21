class_name HealthComponent extends Node

var current_health : float = 100.0

func _ready() -> void:
	Event.Player_Events.player_died.connect(func(playerID : int) -> void: print("[%d] player died: %d" % [multiplayer.get_unique_id(), playerID])) 

@rpc("any_peer", "call_local")
func take_damage(amount : float) -> void:
	if not multiplayer.is_server(): push_warning("Attempting to manage players health from non-authority.")
	current_health -= amount
	if current_health <= 0:
		Event.broadcast_event.rpc(Event.Player_Events.player_died, [get_multiplayer_authority()])
