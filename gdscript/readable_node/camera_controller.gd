extends Node

@onready var body: CharacterBody3D = $".."
@onready var camera: Camera3D = $"../Camera3D"
@export var mouse_sens := 0.25
var isPause := false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # マウスを非表示

func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("esc"):
		isPause = !isPause
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if isPause else Input.MOUSE_MODE_CAPTURED)
	
	# マウスを動かしたとき
	if !isPause and event is InputEventMouseMotion:
		# 横方法は身体を回転
		body.rotate_y(deg_to_rad(-event.relative.x) * mouse_sens)
		# 縦方向はカメラを回転、90度くらいで固定
		camera.rotate_x(deg_to_rad(-event.relative.y) * mouse_sens)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
