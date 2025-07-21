extends Node

var Level_Events : LevelEventsClass = LevelEventsClass.new()
var Network_Events : NetworkEventsClass = NetworkEventsClass.new()

class LevelEventsClass:
	signal level_finished_loading()
	signal change_to_level(new_level : PackedScene)
	signal spawn_players()
	signal cleanup_level()

class NetworkEventsClass:
	signal peer_connected(peer_id : int)
	signal peer_disconnected(peer_id : int)
	signal successfully_created_lobby()
	signal successfully_joined_lobby()
	signal failed_to_join_lobby(err : Error)

@rpc("any_peer", "call_local")
func broadcast_event(event : Signal) -> void:
	event.emit()
