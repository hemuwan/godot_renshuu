extends StaticBody3D

@export var paper_material: StandardMaterial3D
@export var paper_ui_textuer: Texture2D
var toggle := false

func _ready() -> void:
	$MeshInstance3D.material_override = paper_material
	
func interact() -> void:
	toggle = !toggle
	$AudioStreamPlayer3D.play()
	get_node("/root/" + get_tree().current_scene.name + "/UI/paper").texture = paper_ui_textuer
	get_node("/root/" + get_tree().current_scene.name + "/UI/paper").visible = toggle
	get_node("/root/" + get_tree().current_scene.name + "/Player").movable = !toggle
	get_node("/root/" + get_tree().current_scene.name + "/Player/head").movable = !toggle
	
