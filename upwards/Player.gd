extends KinematicBody

const MOVE_SPEED = 6
const H_LOOK_SENS = 0.75
const V_LOOK_SENS = 0.75
const GRAVITY = 0.98
const MAX_FALL_SPEED = 12

onready var cam = $CamBase
onready var steps = $AudioStreamPlayer3D
onready var y_velo = 0

func _input(event):
	if event is InputEventMouseMotion:
		cam.rotation_degrees.x -= event.relative.y * V_LOOK_SENS
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -45, 60)
		rotation_degrees.y -= event.relative.x * H_LOOK_SENS

func _physics_process(delta):
	var move_vec = Vector3()
	if Input.is_action_pressed("walk_forwards"):
		move_vec.z -= 1
		audio()
	if Input.is_action_pressed("walk_backwards"):
		move_vec.z += 1
		audio()
	if Input.is_action_pressed("walk_left"):
		move_vec.x -= 1
		audio()
	if Input.is_action_pressed("walk_right"):
		move_vec.x += 1
		audio()
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_vec *= MOVE_SPEED
	move_vec.y = y_velo
	move_and_slide(move_vec, Vector3(0, 1, 0))
	
	var grounded = is_on_floor()
	y_velo -= GRAVITY
	if grounded and y_velo <= 0:
		y_velo = -0.1
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED
	
	if steps.playing:
		if Input.is_action_just_released("walk_backwards"):
			steps.stop()
		elif Input.is_action_just_released("walk_forwards"):
			steps.stop()
		elif Input.is_action_just_released("walk_left"):
			steps.stop()
		elif Input.is_action_just_released("walk_right"):
			steps.stop()

func audio():
	if is_on_floor():
		if steps.playing:
			return
		else:
			steps.play()
	else:
		steps.stop()
