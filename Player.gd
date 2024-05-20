extends CharacterBody3D

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0
const SPEED = 5.0

@export var sens_horizontal = 0.05
@export var sens_vertical = 0.05

@onready var pitch_pivot := $PitchPivot
@onready var visuals := $PlayerModel
@onready var camera := $PitchPivot/Camera3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	if is_multiplayer_authority():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		camera.current = is_multiplayer_authority()
	
func _input(event):
	if is_multiplayer_authority():
		if event is InputEventMouseMotion:
			visuals.rotate_y(deg_to_rad(event.relative.x*sens_horizontal))
			rotate_y(deg_to_rad(-event.relative.x*sens_horizontal))
			pitch_pivot.rotate_x(deg_to_rad(-event.relative.y*sens_vertical))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		
		var input := Vector3.ZERO
		input.x = Input.get_axis("move_left", "move_right")
		input.z = Input.get_axis("move_forward", "move_back")
		
		if Input.is_action_just_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		var direction = (transform.basis * Vector3(input.x, 0, input.z).normalized())
		visuals.look_at(position + direction)
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0 ,SPEED)
			velocity.z = move_toward(velocity.z, 0 ,SPEED)
		move_and_slide()

