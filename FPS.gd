class_name Player extends CharacterBody3D

@export_category("Player")
@export_range(1, 35, 1) var speed: float = 10 # m/s
@export_range(10, 400, 1) var acceleration: float = 100 # m/s^2

@export_range(0.1, 3.0, 0.1) var jump_height: float = 1 # m
@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1

var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

var mode = false
var jams = 0
var finale = false

@onready var camera: Camera3D = $Head/Camera

func _ready() -> void:
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
	if Input.is_action_just_pressed("jump"):
		var rng = RandomNumberGenerator.new()
		var rng_num = rng.randi_range(0, 1)
		var pitch
		if mode == true:
			pitch = 0.5
		elif mode == false:
			pitch = 1
		if rng_num == 0 and is_on_floor():
			$Head/Camera/Sprite3D/Jump1.pitch_scale = pitch
			$Head/Camera/Sprite3D/Jump1.play()
		elif rng_num == 1 and is_on_floor():
			$Head/Camera/Sprite3D/Jump2.pitch_scale = pitch
			$Head/Camera/Sprite3D/Jump2.play()
		jumping = true
	if Input.is_action_just_pressed("mode_1"):
		$Head/Camera/Sprite3D/Equip.play()
		mode = !mode
	if Input.is_action_just_pressed("exit"): get_tree().quit()

func _physics_process(delta: float) -> void:
	if finale == true:
		await get_tree().create_timer(5).timeout
		$Head/Camera/AnimatedSprite3D/Boom.play()
		$Head/Camera/AnimatedSprite3D.visible = true
		$Head/Camera/AnimatedSprite3D.play("default")
		await get_tree().create_timer(1).timeout
		get_tree().quit()
	$Head/Camera/JamCount.text = str(jams) + "  JAM"
	if mode == false:
		$Head/Camera/Sprite3D.visible = false
		speed = 10
		jump_height = 1
	elif mode == true:
		$Head/Camera/Sprite3D.visible = true
		speed = 5
		jump_height = 4
	if mouse_captured: _handle_joypad_camera_rotation(delta)
	velocity = _walk(delta) + _gravity(delta) + _jump(delta)
	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _handle_joypad_camera_rotation(delta: float, sens_mod: float = 1.0) -> void:
	var joypad_dir: Vector2 = Input.get_vector("look_left","look_right","look_up","look_down")
	if joypad_dir.length() > 0:
		look_dir += joypad_dir * delta
		_rotate_camera(sens_mod)
		look_dir = Vector2.ZERO

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel


func _on_deatharea_3d_body_entered(body):
	if body.name == "Player":
		self.position = Vector3(0, 4, 0)
	elif body.name == "Ball":
		body.position= Vector3(0, 7, 0)
