extends Node3D

var m_f_is_entered_enemy_bullet: bool = false

#func _physics_process(delta) -> void:
	#print(get_tree().get_nodes_in_group("targetEnemy"))


func is_stage_clear() -> bool:
	return get_tree().get_nodes_in_group("targetEnemy").size() == 0

func is_stage_failed() -> bool:
	return m_f_is_entered_enemy_bullet

func _on_enemy_bullet_sensor_body_entered(body):
	m_f_is_entered_enemy_bullet = true
