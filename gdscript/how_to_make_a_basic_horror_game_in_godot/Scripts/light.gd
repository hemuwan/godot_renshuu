extends Node3D

@export var flash_light_at_rand: bool
@export var min_time: float
@export var max_time: float
@export var min_flash_time: float
@export var max_flash_time: float
@export var loop_flashing: bool
var loop := true

func _process(delta):
	if loop == true && flash_light_at_rand == true:
		loop = false
		var rng = RandomNumberGenerator.new() # 乱数ジェネレータ
		var rand = rng.randf_range(min_time, max_time) # 最小から最大の間のどれか
		await get_tree().create_timer(rand, false).timeout # arg2:false -> 一時停止されていないときのみ機能する
		if loop_flashing == true:
			$AnimationPlayer.get_animation("flashing_light").loop = true
		$AnimationPlayer.play("flashing_light")
		$flicker_sound.play()
		if loop_flashing == false:
			await get_tree().create_timer(1.5, false).timeout
			$AnimationPlayer.play("RESET")
			$flicker_sound.stop()
			loop = true
		if loop_flashing == true:
			var rand2 = rng.randf_range(min_flash_time, max_flash_time)
			await get_tree().create_timer(rand2, false).timeout
			$AnimationPlayer.play("RESET")
			loop = true
			
