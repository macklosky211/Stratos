class_name ScoreManager extends Node

## How many rounds a player needs to win the map.
var rounds_per_map : int = 2
var maps_per_game : int = 4

## Mapped PlayerID -> Score.
var round_score : Dictionary[int, int]

## Mapped PlayerID -> Score.
var map_score : Dictionary[int, int]

func _ready() -> void:
	Event.Level_Events.round_won.connect(func(playerID : int) -> void: won_round.rpc_id(1, playerID))
	Event.Level_Events.map_won.connect(func(playerID : int) -> void: won_map.rpc_id(1, playerID))
	Event.Global_Events.setup_game.connect(setup_scores)

func setup_scores() -> void:
	for playerID : int in Network.players:
		round_score[playerID] = 0
		map_score[playerID] = 0

## Call when a player wins a round.
@rpc("authority", "call_local")
func won_round(playerID : int) -> void:
	print("[%d] won_round was called by %d" % [multiplayer.get_unique_id(), multiplayer.get_remote_sender_id()])
	round_score[playerID] += 1
	if round_score[playerID] == rounds_per_map:
		Event.Level_Events.map_won.emit(playerID)

@rpc("authority", "call_local")
func won_map(playerID : int) -> void:
	reset_round_scores()
	map_score[playerID] += 1
	if map_score[playerID] == maps_per_game:
		Event.broadcast_event(Event.Global_Events.game_finshed, [playerID])

func reset_round_scores() -> void:
	for playerID : int in round_score.keys():
		round_score[playerID] = 0
