extends Button

signal decrement(new_value: int)

func _on_pressed() -> void:
	decrement.emit(1)
