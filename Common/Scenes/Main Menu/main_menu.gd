extends Control

func _ready() -> void:
	Event.Network_Events.successfully_created_lobby.connect(joined_lobby)
	Event.Network_Events.successfully_joined_lobby.connect(joined_lobby)
	Event.Network_Events.failed_to_join_lobby.connect(failure_message)

func _on_start_button_pressed() -> void:
	start_lobby.rpc()

@rpc("any_peer", "call_local")
func start_lobby() -> void:
	get_tree().change_scene_to_file("res://Assets/Levels/demo_level.tscn")

func failure_message(error : Error) -> void:
	$"Lobby Tooltip".text = "Multiplayer Networking Failed With Error: %d" % error

func joined_lobby() -> void:
	$"Lobby Tooltip".text = "Ready!"
	$"Start Button".disabled = false

func _host_lobby() -> void:
	Network.host_server()

func _join_lobby() -> void:
	var address : String = $IP_ADDRESS_BOX.text
	if not address.is_valid_ip_address() and address != "localhost": 
		$"Lobby Tooltip".text = "Address is not a valid ip address. Try Again."
		return
	Network.join_server(address)
