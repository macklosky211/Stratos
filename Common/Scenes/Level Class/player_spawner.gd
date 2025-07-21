extends MultiplayerSpawner

var player_scene : PackedScene = preload("res://Entities/Player/player.tscn")

func _ready() -> void:
	spawn_function = spawn_player

func spawn_player(vars : Array) -> Node:
	var steamID : int = vars[0]
	
	var player : Node = player_scene.instantiate()
	player.name = str(steamID)
	
	## Not sure I want to give authority to anyone who isnt the server... may change this later
	## TODO: Figure this out.
	player.set_multiplayer_authority(steamID, true)
	return player
