extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var sens := 0.005; #マウス感度
var movable := true;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED; # マウスカーソルを消す。

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "front", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	# いったんマウス系じゃなければスルー
	if event is not InputEventMouseMotion || !movable: return;
	rotate_y(-event.relative.x * sens); # マウスの動きに合わせてPlayerを水平回転
	$head.rotate_x(-event.relative.y * sens); # マウスの動きに合わせてheadを垂直回転
	$head.rotation.x = clamp($head.rotation.x, deg_to_rad(-90),deg_to_rad(90)); # 回転の範囲をクランプ（制限）
		
		
