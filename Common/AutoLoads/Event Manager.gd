extends Node

var Level_Events : LevelEventsClass = LevelEventsClass.new()
var Network_Events : NetworkEventsClass = NetworkEventsClass.new()
var Player_Events : PlayerEventsClass = PlayerEventsClass.new()
var Global_Events : GlobalEventsClass = GlobalEventsClass.new()

class GlobalEventsClass:
	signal game_finshed(playerID_who_won : int) ## Emits when a player wins the overall game.
	signal setup_game() ## Emits when the players are attempting to PLAY the game.

class LevelEventsClass:
	signal level_finished_loading()
	signal change_to_level(new_level : PackedScene)
	signal spawn_players()
	signal cleanup_level()
	signal round_won(playerID : int)
	signal map_won(playerID: int)

class PlayerEventsClass:
	signal player_died(playerID : int)

class NetworkEventsClass:
	signal peer_connected(peer_id : int)
	signal peer_disconnected(peer_id : int)
	signal successfully_created_lobby()
	signal successfully_joined_lobby()
	signal failed_to_join_lobby(err : Error)

@rpc("any_peer", "call_local")
func broadcast_event(event : Signal, args : Array = []) -> void:
	match args.size():
		0: event.emit()
		1: event.emit(args[0])
		2: event.emit(args[0], args[1])
		3: event.emit(args[0], args[1], args[2])
		_: push_error("Attempting to broadcast an RPC event with more than 3 arguments.")
