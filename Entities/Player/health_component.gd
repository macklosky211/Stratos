class_name HealthComponent extends Node

@export var MAX_HP : float = 100.0

var current_health : float = 100.0

@rpc("any_peer", "call_local")
func take_damage(amount : float) -> void:
	if not is_multiplayer_authority(): push_error("Take Damage was called by client that did not have authority. [%d]" % multiplayer.get_remote_sender_id())
	
	current_health -= amount
	if is_dead():
		#print("[%d] I am going to broadcast that I have died." % multiplayer.get_unique_id())
		Event.broadcast_event.rpc(Event.Player_Events.player_died, [get_multiplayer_authority()])

func is_dead() -> bool:
	return current_health <= 0.0

func reset() -> void:
	current_health = MAX_HP
