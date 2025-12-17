extends Node

# Boxを生成する処理

func _ready() -> void:
	# 10 * 10 + 10 = 1000 でぎりぎり
	for i in range(10):
		for j in range(10):
			for k in range(10):
					var body = gen_box()
					# 位置
					body.position = Vector3(
						k,
						10 + j,
						i
					)
					$".".add_child(body)

func gen_box() -> RigidBody3D:
	# 動的なオブジェクト
	var body = RigidBody3D.new()
	
	# 衝突形状
	var shape = CollisionShape3D.new()
	shape.shape = BoxShape3D.new()
	body.add_child(shape)
	
	# 見た目
	var mesh = MeshInstance3D.new()
	mesh.mesh = BoxMesh.new()
	body.add_child(mesh)
	
	return body
