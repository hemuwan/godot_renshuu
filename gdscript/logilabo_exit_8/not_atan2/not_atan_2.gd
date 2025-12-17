extends RigidBody3D

# タンジェント使った方がわかりやすい。look_at 関数なるものがあった
# 便利だけどぱっとむいちゃう。じわっと向くにはどうしたら。
var player: CharacterBody3D;
var trigger: bool = false;

@export var turn_speed := 3.0  # 回転スピード（大きいほど早く向く）

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/" + get_tree().current_scene.name + "/Player");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if trigger:
		print(2)
		# 自分の位置とプレイヤーの位置を取得
		var my_pos = global_transform.origin
		var target_pos = player.global_transform.origin
		# 今の回転
		var current_basis = global_transform.basis
		
		# 向かせたい向き（Z軸前方）をターゲットに向けた basis を作る
		var target_basis = Basis().looking_at(target_pos - my_pos, Vector3.UP)
		# 球面補間で滑らかに回転を近づける
		var new_basis = current_basis.slerp(target_basis, delta * turn_speed)
		# 回転だけを更新
		global_transform.basis = new_basis


func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body)
	if body is not CharacterBody3D: return;
	trigger = true;


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is not CharacterBody3D: return;
	trigger = false;
