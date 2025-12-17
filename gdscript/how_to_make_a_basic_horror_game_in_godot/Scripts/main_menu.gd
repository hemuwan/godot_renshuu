extends Control


func play() -> void:
	get_tree().change_scene_to_file("res://Scenes/level.tscn")

func quit() -> void:
	get_tree().quit() # ゲームを終了する
