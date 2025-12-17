extends Node3D

var player

func _ready() -> void:
	player = get_node("/root/" + get_tree().current_scene.name + "/Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# monsterグループに所属している全てのノードのupdate_target_location関数を呼び出し、引数にプレイヤーの位置を入れている
	get_tree().call_group("monster", "update_target_location", player.global_transform.origin)
