extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var isPause := false;
var mouse_sens := 0.25;

@onready var camera := $"./Camera3D"

func _ready() -> void:
	# デフォルトでマウスを非表示
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# inputmap 更新
	var key_bindings := {
		"up": KEY_W,
		"left": KEY_A,
		"right": KEY_D,
		"down": KEY_S
	}
	for action in key_bindings:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			
		var ev := InputEventKey.new()
		ev.keycode = key_bindings[action]
		InputMap.action_add_event(action, ev)

func _input(event: InputEvent) -> void:
	# InputMap が面倒なのでキーコードを使いたい -> esc くらいならできたが、移動の処理が面倒。
	# キーイベントかつ、何かしらが押されたとき、
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			isPause = !isPause
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if isPause else Input.MOUSE_MODE_CAPTURED)
	# インプットマップを設定した方が簡単に書ける。
	#if Input.is_action_just_pressed("esc"):
		#isPause = !isPause
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if isPause else Input.MOUSE_MODE_CAPTURED)
	
	# マウスを動かしたとき
	if !isPause and event is InputEventMouseMotion:
		# 横方法は身体を回転
		rotate_y(deg_to_rad(-event.relative.x) * mouse_sens)
		# 縦方向はカメラを回転、90度くらいで固定
		camera.rotate_x(deg_to_rad(-event.relative.y) * mouse_sens)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
