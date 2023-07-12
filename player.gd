extends CharacterBody3D

@export var movement_speed = 5.0
@export var mouse_sensitivity = 0.3
@export var jump_height = 5.0
@export var jump_time = 0.5
@export var gravity = 9.8
@export var max_look_up = 90
@export var max_look_down = -90

var camera_rotation = Vector2.ZERO
var is_grounded = false
var jump_timer = 0

@onready var mirror_camera = get_tree().get_root().get_node("Main/Mirror/MirrorMesh/SubViewport/Camera3D")

# Called when the node enters the scene tree for the first time.
func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    pass # Replace with function body.

func _input(event):
    if event is InputEventMouseMotion:
        camera_rotation -= event.relative * mouse_sensitivity
        camera_rotation.y = clamp(camera_rotation.y, max_look_down, max_look_up)

    if event.is_action_pressed("cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    if event.is_action_pressed("left_click"):
        if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    var move_vector = Vector3.ZERO

    move_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
    move_vector.z = Input.get_action_strength("backward") - Input.get_action_strength("forward")
    move_vector = move_vector.normalized()

    var forward = transform.basis.z
    var right = transform.basis.x

    var movement_direction = forward * move_vector.z + right * move_vector.x
    movement_direction.y = 0.0
    movement_direction = movement_direction.normalized()

    velocity = movement_direction * movement_speed

    velocity.y -= gravity * delta

    if is_grounded and Input.is_action_just_pressed("jump"):
        jump_timer = jump_time

    if jump_timer > 0.0:
        velocity.y = jump_height
        jump_timer -= delta

    rotation.y = deg_to_rad(camera_rotation.x)
    $Camera3D.rotation.x = deg_to_rad(camera_rotation.y)

    move_and_slide()

    is_grounded = is_on_floor()

    if is_grounded and velocity.y < 0:
        velocity.y = 0.0

    # handle mirror
    # mirror_camera.update_cam(global_transform)

