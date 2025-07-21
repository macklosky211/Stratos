extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var mouse_sensitivity : float = 0.001
var mouse_locked : bool = false

func _ready() -> void:
	if not is_multiplayer_authority():
		$MeshInstance3D/Glasses.layers = 1
		#print("[%d] does not own {%s : %d}" % [multiplayer.get_unique_id(), name, get_multiplayer_authority()])
	else:
		camera.make_current()

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	if not is_on_floor(): velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("Jump") and is_on_floor(): velocity.y = JUMP_VELOCITY
	
	if mouse_locked and Input.is_action_just_pressed("Escape"): toggle_mouse(false)
	
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		camera.rotation.x -= event.relative.y * mouse_sensitivity
		rotation.y -= event.relative.x * mouse_sensitivity
	elif not mouse_locked and Input.is_action_just_pressed("Fire"):
		toggle_mouse(true)

func toggle_mouse(val : bool = not mouse_locked) -> void:
	mouse_locked = val
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if mouse_locked else Input.MOUSE_MODE_VISIBLE
