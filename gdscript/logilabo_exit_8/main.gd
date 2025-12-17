extends Node

# checkpoint を抜けてエリアを消したり置いたりする処理、
# main に書くこともできるが、シグナル増やしたり、
# get_tree().current_scene.get_node("/root")
# とかしないといけないか？	
@export var target_node: RigidBody3D
@onready var label_node: Label = $CanvasLayer/Label
@onready var camera: Camera3D = $Player/head/Camera3D
@onready var player: CharacterBody3D = $Player

func _ready() -> void:
	target_node = $not_atan2
	
	#$exit0.CheckPoint_out.connect(create_area)
#
#func create_area(active_area):
	## アクティブエリア以外は削除する。
	##var maps = get_tree().get_nodes_in_group("maps") # グループに属するノードをリストで取得、引数にグループ名
	##for map in maps:
		##if map != active_area:
			##map.queue_free()
			#pass
			
func _process(delta):
	# 対象物の座標を元に、UIの座標を移動させる。
	var world_position = target_node.global_transform.origin
	if camera.is_position_behind(world_position): return # カメラの背面なら処理しない
	var screen_position = camera.unproject_position(world_position)
	screen_position.y -= 50
	label_node.position = screen_position
	
	# Pleyer から対象物への方向を計算
	var diff = world_position - player.global_transform.origin
	#print(diff)
	var normalize = diff.normalized()
	#print(normalize)
