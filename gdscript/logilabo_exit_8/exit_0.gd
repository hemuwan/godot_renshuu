extends Node3D
signal CheckPoint_out
const EXIT_0 = preload("res://exit_0.tscn") # Ctrl + D&D で簡単に書ける。

var next_area;

var in_pos
var out_pos

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_check_point_body_exited(body: Node3D) -> void:
	# エリアに入った時の座標で向きを判断する。
	out_pos = body.position
	var body_direction
	
	# プレイヤーがどっちの方向に進んでいるのかチェック
	if (in_pos.z - out_pos.z ) < 0:
		body_direction = 1
	else:
		body_direction = -1
		
	#CheckPoint_out.emit(self, body_direction)
	
	# マップの向きが正方向か逆方向か, if 式
	var map_direction = 1 if rotation.y == 0 else -1
	
	
	#CheckPoint_out.emit(self) # マップを入れてどのマップにいるか判別する。
	var maps = get_tree().get_nodes_in_group("maps") # グループに属するノードをリストで取得
	for map in maps:
		if map != self:
			map.queue_free()
	
	var main = get_tree().current_scene.get_node("/root/Main")
	next_area = EXIT_0.instantiate()
	
	#next_area.position.x = self.position.x - 8.0
	#next_area.position.y = self.position.x - 30.0 # 上下にできてしまう。
	
	if body_direction == 1:
		next_area.position.x = self.position.x - 30.0
		next_area.position.z = self.position.z + 8.0
	else:
		next_area.position.x = self.position.x + 30.0
		next_area.position.z = self.position.z - 8.0
		next_area.rotation.y = PI # PI は180度
	
	main.add_child(next_area)
	


func _on_check_point_body_entered(body: Node3D) -> void:
	in_pos = body.position # 入った時のポジションを保持。
