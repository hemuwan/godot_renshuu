extends Button

# ポーズ画面からのゲーム再開の合図。
signal resume

func _on_pressed() -> void:
	resume.emit()
