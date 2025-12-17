extends CharacterBody3D

@export var m_speed_mps: float = 5.0
@export var m_ray_length_m: int = 1000
# PackedScene クラスの方を宣言して インスペクタに表示
#@export var m_scn_bullet: PackedScene
var m_scn_bullet: PackedScene = preload("res://components/bullet.tscn")

var m_touch_pos : Vector2 = Vector2.ZERO
var m_d_move_to_pos_x_m = 0
var m_f_is_screen_touch = false

func _ready():
	$timer_fire.wait_time = GlobalSetting.m_firing_timing_sec

func _input(event):
	if(event is InputEventScreenDrag) or (event is InputEventScreenTouch):
		m_touch_pos = event.position
		# スマホタッチ中フラグ
		m_f_is_screen_touch = event.is_pressed() or (event is InputEventScreenDrag)
		
func _physics_process(delta):
	# 今表示しているカメラを取得
	var camera = get_viewport().get_camera_3d()
	
	# カメラを利用して３D 空間のカメラ位置タッチしたピクセルに対応する方向の1000m 先の位置を計算する
	# project_ray_origin -> 引数の値からカメラの位置を取得
	# preject_ray_normal -> カメラから引数の値の方向を取得
	var from3d = camera.project_ray_origin(m_touch_pos)
	var to3d = from3d + camera.project_ray_normal(m_touch_pos) * m_ray_length_m
	
	# 3D ray physics query の作成
	var query = PhysicsRayQueryParameters3D.create(from3d, to3d)
	query.collide_with_areas = true # Area3D を検知できる良い鵜にする
	
	# Godotの3Dの物理とコリジョンを保存している
	# space という情報を使用してオブジェクト検出
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	if result:
		m_d_move_to_pos_x_m = result.position.x
		
	# 移動制御は毎週実行する
	var d_diff_x_m = (m_d_move_to_pos_x_m - transform.origin.x)
	var d_speed_mps = m_speed_mps if d_diff_x_m > 0 else -m_speed_mps # 正負反転しているだけ
	var d_move_diff_x_m = d_speed_mps * delta
	if absf(d_move_diff_x_m) > absf(d_diff_x_m):
		# 移動すると目標位置を超えるため、目標位置を設定
		transform.origin.x = m_d_move_to_pos_x_m
	else:
		move_and_collide(Vector3(d_move_diff_x_m, 0, 0))


func _on_timer_fire_timeout():
	# スマホタッチ中の場合、発射する
	if m_f_is_screen_touch:
		var scn_bullet = m_scn_bullet.instantiate()
		# scn_bullet.transform.origin = transform.origin
		# 子ノードは「$ + ノード名」シーンからエディターにD＆Dすると相対パスも考慮してくれる。
		scn_bullet.transform.origin = $Marker3D.global_transform.origin
		add_sibling(scn_bullet)
