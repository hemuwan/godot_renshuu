extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		# ゲーム全体を一時停止する ポーズ
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		if get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # 実行中マウスカーソルが表示される
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # 実行中マウスカーソルが消える。

# ゲームにもどる
func resume():
	get_tree().paused = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# タイトル画面に戻る	
func back_to_menu():
	get_tree().paused = false # これ入れないと、メインメニュー操作できない
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
# ゲームを閉じる
func quit_game():
	get_tree().quit();
