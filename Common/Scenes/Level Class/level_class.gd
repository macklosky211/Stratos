class_name Level extends Node3D

@export_category("Per Level Settings")
@export var player_spawn_locations : Array[Marker3D] = []
@export var level_gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

var original_gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

func _ready() -> void:
	Event.Level_Events.spawn_players.connect(spawn_players)
	Event.Level_Events.cleanup_level.connect(cleanup_level_handler)
	
	Event.Level_Events.spawn_players.emit()
	Event.Level_Events.level_finished_loading.emit()

## Used to index where players will spawn next. right now its just a round robin.
var last_spawned_location_index : int = 0

func spawn_players() -> void:
	if not multiplayer.is_server(): return
	assert(player_spawn_locations.size() > 0)
	
	for playerID : int in Network.players:
		$"Constant Elements/Player_Spawner".spawn([playerID, player_spawn_locations[last_spawned_location_index].position])
		last_spawned_location_index = (last_spawned_location_index + 1) % player_spawn_locations.size()

func cleanup_level_handler() -> void:
	ProjectSettings.set_setting("physics/3d/default_gravity", original_gravity)

func _on_world_boundry_body_entered(body: Node3D) -> void:
	if body is not Player: return
	body = body as Player # TODO: This is simply so the editor shows us autofil info.
	body.health.take_damage.rpc_id(1, 100000) # the player SHOULNDT have 100k health... I hope
