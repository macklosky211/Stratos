class_name Player extends State_Controller

@onready var camera : Camera3D = $Camera3D
@onready var health : HealthComponent = $HealthComponent

const WALK_SPEED : float = 5.0
const SPRINT_SPEED : float = WALK_SPEED * 2.0
const CROUCH_SPEED : float = WALK_SPEED * 0.5
const JUMP_VELOCITY : float = 3.5
const AIR_SPEED : float = 3.0

const ACCEL : float = 2.5

var mouse_sensitivity : float = 0.001
var mouse_locked : bool = false
var is_crouching : bool = false
var should_gravity: bool = true

#states
@onready var Walking: State = $States/Walking
@onready var Sprinting: State = $States/Sprinting
@onready var Sliding: State = $States/Sliding
@onready var Crouching: State = $States/Crouching
@onready var Idle: State = $States/Idle
@onready var vaulting: Node = $States/Vaulting

func _ready() -> void:
	if not is_multiplayer_authority():
		$MeshInstance3D/Glasses.layers = 1
		#print("[%d] does not own {%s : %d}" % [multiplayer.get_unique_id(), name, get_multiplayer_authority()])
	else:
		current_state = Idle
		camera.make_current()

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	if current_state is Object and current_state.has_method("_update"): current_state._update(self, delta)
	if not is_on_floor() and should_gravity: velocity += get_gravity() * delta
	move_and_slide()

@rpc("any_peer", "call_local")
func reset() -> void:
	health.reset()

func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		camera.rotation.x -= event.relative.y * mouse_sensitivity
		rotation.y -= event.relative.x * mouse_sensitivity
	elif not mouse_locked and Input.is_action_just_pressed("Fire"): toggle_mouse(true)
	elif Input.is_action_just_pressed("Escape"): toggle_mouse()

func _get_world_direction_from_input(local_vector : Vector2) -> Vector3:
	return (transform.basis * Vector3(local_vector.x, 0, -local_vector.y)).normalized()

func toggle_mouse(val : bool = not mouse_locked) -> void:
	mouse_locked = val
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if mouse_locked else Input.MOUSE_MODE_VISIBLE


@onready var bottom_collision: RayCast3D = $Bottom_Collision
@onready var waist_collision: RayCast3D = $Waist_Collision
@onready var landing: RayCast3D = $Landing
func _try_vault() -> bool:
	if bottom_collision.is_colliding() and not waist_collision.is_colliding():
		return true
	return false
	
