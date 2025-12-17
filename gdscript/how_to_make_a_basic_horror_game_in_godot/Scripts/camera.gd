extends Node3D

# マウス感度
var sens = 0.005
var movable = false

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) v4.3 で消えた
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # これでOK、実行中マウスカーソルが消える。
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && movable == true:
		get_parent().rotate_y(-event.relative.x * sens) # マウスの動きに合わせてPlayerを水平回転
		rotate_x(-event.relative.y * sens) # マウスの動きに合わせて、head の縦方向を回転、頭が回転
		
		# 回転の範囲をクランプ、（制限）
		# 最小クランプが -90 最大クランプが 90
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
