extends Node3D



@onready var model_holder: Interactable = $Model_Holder

@export var weapon_scene : PackedScene
@export var time_to_spawn : float = 2.0

var timer : float = time_to_spawn
var on_cooldown : bool = false

func _ready() -> void:
	assert(weapon_scene, "Weapon_Scene not set.")
	model_holder.interacted.connect(interact)
	set_process(false)

func interact(_player : Player) -> void:
	if on_cooldown: return
	set_process(true)
	on_cooldown = true
	timer = time_to_spawn
	model_holder.visible = false

func _process(delta: float) -> void:
	if timer > 0:
		timer -= delta
		print(timer)
	else:
		model_holder.visible = true
		on_cooldown = false
		set_process(false)
