extends Button

signal increment

func _on_pressed() -> void:
	print("ボタンが押された！")
	increment.emit()
