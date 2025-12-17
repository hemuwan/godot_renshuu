extends Button

signal add_ten(num)

func _on_pressed() -> void:
	add_ten.emit(10)
