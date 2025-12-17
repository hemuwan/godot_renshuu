extends CharacterBody3D

@export var m_v_dir := Vector3.FORWARD
@export var m_d_speed_mps := 2.0

@export var m_attack_power_ps := 1.0
@export var m_hp := 1

# null 許容の方 pos : Vector3 | null = null とか
var m_v3_sensing_pos = null
var m_v3_enemy_pos = null

# 通過したMultiplicationArea を記憶するための辞書
var m_dict_multiarea_ids: Dictionary = {}

func _physics_process(delta):
	if m_v3_enemy_pos:
		m_v_dir = m_v3_enemy_pos - transform.origin
	else:
		m_v_dir = Vector3.FORWARD
	velocity = m_v_dir.normalized() * m_d_speed_mps
	move_and_slide()
	
	# バトル判定
	# move_and_slide の結果、衝突した回数
	# (衝突により方向を変えた回数)を取得し、for ループ
	var battle_pos = null
	for index in range(get_slide_collision_count()):
		# get_slide_collision 配列を返す？
		# index番目の衝突情報をcollisionとして取り出している
		var collision = get_slide_collision(index)
		if (collision.get_collider() == null):
			# 衝突情報がない
			continue
		if collision.get_collider().is_in_group("enemyGroup"):
			# 衝突したノードが指定のグループに属しているかチェック
			# ノードインスタンスを取得
			var enemy = collision.get_collider()
			
			# バトル中に相手の位置を保持
			battle_pos = enemy.transform.origin
			
			# bullet の攻撃
			enemy.m_hp -= m_attack_power_ps * delta
			# enemy の攻撃
			m_hp       -= enemy.m_attack_power_ps * delta
	# HP が0になったら消える
	if m_hp < 0:
		queue_free()
		
	# バトル中の相手、センシングした敵の順に目標位置を設定する
	if battle_pos:
		m_v3_enemy_pos = battle_pos
	elif m_v3_sensing_pos:
		if (m_v3_sensing_pos - transform.origin).length() < 0.1:
			m_v3_sensing_pos = null
		m_v3_enemy_pos = m_v3_sensing_pos
	else:
		m_v3_enemy_pos = null
	
func discover_enemy(enemy_pos):
	m_v3_sensing_pos = enemy_pos
	
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func _on_multiplication_area_derecter_area_entered(area: Area3D):
	# get_instance_id() でオブジェクト固有のインスタンスID取得
	if m_dict_multiarea_ids.has(area.get_instance_id()):
		pass
	else:
		# 倍率ー1人増える
		var i_add_num = area.m_i_magnification - 1
		var d_add_x = -0.15;
		var d_add_z = 0.1
		for i in range(i_add_num):
			m_dict_multiarea_ids[area.get_instance_id()] = true;
			var avater: CharacterBody3D = duplicate();
			# 分身の辞書は初期値なので、オリジナルのm_dict_multiarea_ids をコピー
			# 辞書は参照コピーになるため、duplicate(true) で深いコピーを作成して渡す
			avater.m_dict_multiarea_ids = m_dict_multiarea_ids.duplicate(true);
			avater.transform.origin += Vector3(d_add_x, 0, d_add_z);
			add_sibling(avater);
			
			d_add_z = -d_add_z
			d_add_z += 0.1
