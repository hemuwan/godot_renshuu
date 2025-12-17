# モンスタースポーンを制御するスクリプト
extends Area3D

@export var monster: CharacterBody3D

func spawn_monster(body) -> void:
	if body == get_node("/root/" + get_tree().current_scene.name + "/Player"):
		monster.visible = true
