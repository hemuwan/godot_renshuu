extends Node3D

enum EN_GAME_STS {
	READY,
	IN_PLAY,
	STAGE_CLEAR,
	STAGE_FAILED,
}
var m_en_game_sts := EN_GAME_STS.READY

# ステージリスト
var m_nodearray_stages: Array[PackedScene] = [
	preload("res://stages/stage001.tscn"),
	preload("res://stages/stage002.tscn"),
	preload("res://stages/stage003.tscn"),
]
# 現在実行中のステージ番号
var m_i_current_stage_idx: int = 0
# タッチイベント処理用
var m_f_touch: bool = false

func _input(event) -> void:
	if(event is InputEventScreenTouch ) and event.pressed:
		m_f_touch = true

func set_new_stage(idx) -> void:
	# currentStage にあるすべてを削除する
	#var nodes := $currentStage.get_children() # 問題ない
	var nodes: Array[Node] = $currentStage.get_children()
	for node: Node in nodes:
		node.queue_free()
	# idx 番目のステージシーンのインスタンスを生成して、currentStage に追加する
	var new_stage = m_nodearray_stages[idx].instantiate()
	$currentStage.add_child(new_stage)

func hide_all_messages() -> void:
	# メッセージ表示をすべて隠す
	var nodes: Array[Node] = $messages.get_children()
	for node: Node in nodes:
			node.hide()

func _ready() -> void:
	set_new_stage(m_i_current_stage_idx)

func _physics_process(delta) -> void:
	match m_en_game_sts:
		EN_GAME_STS.READY:
			# 画面タッチされたら、READY表示を消してプレイ中にする
			if m_f_touch:
				hide_all_messages()
				m_en_game_sts = EN_GAME_STS.IN_PLAY
				# "gameControl" グループを持つ、player と enemy のスクリプトのgame_start() メソッドを起動する
				get_tree().call_group("startStopControl", "game_start")
				# GO を表示して2秒後にメッセージを消す
				$messages/go.show()
				await get_tree().create_timer(2.0).timeout
				hide_all_messages()
		EN_GAME_STS.IN_PLAY:
			var nodes: Array[Node] = $currentStage.get_children()
			if nodes:
			# nodes は1個か0個のどちらかなので、0番目を固定的に使用する
				if nodes[0].is_stage_clear():
					# ゲーム状態を「ステージクリア」状態にして、「StageClear」を表示
					m_en_game_sts = EN_GAME_STS.STAGE_CLEAR
					hide_all_messages()
					$messages/stageClear.show()
				if nodes[0].is_stage_failed():
					m_en_game_sts = EN_GAME_STS.STAGE_FAILED
					hide_all_messages()
					$messages/stageFailred.show()
		EN_GAME_STS.STAGE_CLEAR:
			# 画面タッチされたらReadyに遷移する
			if m_f_touch:
				# 次のステージにすすむ
				# ステージは０，１，２，０，１，２，０と繰り返す
				m_i_current_stage_idx = (m_i_current_stage_idx + 1) % m_nodearray_stages.size()
				set_new_stage(m_i_current_stage_idx)
				# ゲーム状態を「レディ」にしてテキスト表示
				m_en_game_sts = EN_GAME_STS.READY
				hide_all_messages()
				$messages/ready.show()
		EN_GAME_STS.STAGE_FAILED:
			# 画面タッチされたらReady に遷移
			if m_f_touch:
				Global.goto_scene("res://title.tscn")
	# _physics_process() の最後に m_f_touch フラグを落とす
	m_f_touch = false
# -> _physics_process()

