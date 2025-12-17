extends RayCast3D
	
func _process(delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		if hit.has_method("interact"):
			hit.interact()
