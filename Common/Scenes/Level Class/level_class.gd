class_name Level extends Node3D

@onready var bullet_folder: Node = $"Constant Elements/Bullet Folder"

@export_category("Per Level Settings")
@export var player_spawn_locations : Array[Marker3D] = []
@export var level_gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

var original_gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

var alive_players : Array[int]

func _ready() -> void:
	Event.Level_Events.map_won.connect(cleanup_level_handler)
	Event.Level_Events.round_won.connect(reset_after_round.rpc)
	Event.Player_Events.player_died.connect(player_died)
	
	Event.Level_Events.level_finished_loading.emit()
	spawn_players()

## Used to index where players will spawn next. right now its just a round robin.
var last_spawned_location_index : int = 0

func spawn_players() -> void:
	if not multiplayer.is_server(): return
	assert(player_spawn_locations.size() >= Network.max_players)
	
	for playerID : int in Network.players:
		$"Constant Elements/Player_Spawner".spawn([playerID])
		alive_players.append(playerID)
	position_players.rpc()

## Set global variables back to their original values.
func cleanup_level_handler(_playerID : int) -> void:
	ProjectSettings.set_setting("physics/3d/default_gravity", original_gravity)

## Reset the map after a player has won the round.
@rpc("any_peer", "call_local")
func reset_after_round(_playerID: int) -> void:
	print("[%d] Attempting to reset after round has finished." % multiplayer.get_unique_id())
	
	alive_players.clear()
	
	for player : Node in $"Constant Elements/Players".get_children():
		player.reset()
		alive_players.append(player.name.to_int())
	position_players()

func player_died(playerID : int) -> void:
	alive_players.erase(playerID)
	if alive_players.size() == 1:
		if multiplayer.is_server():
			Event.Level_Events.round_won.emit(alive_players[0])

@rpc("any_peer", "call_local")
func position_players() -> void:
	for player : Player in $"Constant Elements/Players".get_children():
		player.position = player_spawn_locations[last_spawned_location_index].position
		last_spawned_location_index = (last_spawned_location_index + 1) % player_spawn_locations.size()

## This is the world boundry collider, anyone who falls below it should die.
func _on_world_boundry_body_entered(body: Node3D) -> void:
	if body is not Player: return
	body = body as Player # TODO: This is simply so the editor shows us autofil info.
	body.health.take_damage.rpc_id(body.get_multiplayer_authority(), 100000) # the player SHOULNDT have 100k health... I hope
