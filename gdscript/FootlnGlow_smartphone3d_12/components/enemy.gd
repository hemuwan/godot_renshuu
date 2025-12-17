extends CharacterBody3D

@export var m_attack_power_ps = 1.0
@export var m_hp = 10
@export var m_scn_enemyDefeatedAnim : PackedScene;

var m_scn_enemyBullet: PackedScene = load("res://components/enemyBullet.tscn")
@export var m_i_fire_num = 3
var m_i_remain_fire_cnt = 0

func _physics_process(delta):
	if m_hp < 0.0:
		var ins := m_scn_enemyDefeatedAnim.instantiate();
		ins.transform.origin = transform.origin
		add_sibling(ins) # 生成したシーンをEnemyと同じ階層に追加
		ins.animation_play("Defeated");
		queue_free()

func game_start() -> void:
	$Timer_fire.start()

func game_stop() -> void:
	$Timer_fire.stop()

func _on_bullet_sensor_body_entered(body):
	# body には bullet が入ってくる想定
	# ノードインスタンス事態なので、bullet メンバーにアクセスしたり、
	# メソッドを呼ぶことが出来る。
	#print(body)
	body.discover_enemy(transform.origin)

# インスペクター側で6秒周期で発火設定
# 発射段数初期化、発射用ショートタイマー開始
func _on_timer_fire_timeout():
	# 発射する段数を設定
	m_i_remain_fire_cnt = m_i_fire_num
	# タイマースタート
	$Timer_short.start()

# 0.5 秒間隔で3発発射するためのタイムアウト処理。3発でタイマー停止
func _on_timer_short_timeout():
	# EnemyBulletを発射する
	var scn_enemyBullet = m_scn_enemyBullet.instantiate()
	scn_enemyBullet.transform.origin = $Marker3D.global_transform.origin
	add_sibling(scn_enemyBullet)
	
	# 発射残数を減産して、0になったらタイマーを停止する
	m_i_remain_fire_cnt -= 1
	if m_i_remain_fire_cnt <= 0:
		$Timer_short.stop()
