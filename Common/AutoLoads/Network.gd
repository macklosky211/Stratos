extends Node

@export var desired_port : int = 25565
@export var max_players : int = 4

## Stores all players steamID's, used to spawn players when each level is loaded.
## NOTE: player_id 1 will be in this as well. but its not a valid steamID.
var players : Array[int] = [1]

func _ready() -> void:
	multiplayer.peer_connected.connect(func(player_id : int) -> void: players.append(player_id))
	multiplayer.peer_disconnected.connect(func(player_id : int) -> void: players.erase(player_id))

func host_server() -> void:
	var peer : MultiplayerPeer = ENetMultiplayerPeer.new()
	var err : Error = peer.create_server(desired_port, max_players)
	if err != OK:
		Event.Network_Events.failed_to_join_lobby.emit(err)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.multiplayer_peer = peer
	
	Event.Network_Events.successfully_created_lobby.emit()

func join_server(address : String) -> void:
	var peer : MultiplayerPeer = ENetMultiplayerPeer.new()
	var err : Error = peer.create_client(address, desired_port)
	if err != OK:
		Event.Network_Events.failed_to_join_lobby.emit(err)
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.multiplayer_peer = peer
	
	Event.Network_Events.successfully_joined_lobby.emit()
