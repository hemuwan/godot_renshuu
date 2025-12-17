extends Area3D

@export var animationPlayer: AnimationPlayer
@export var anim_name: String
@export var scare_sound: AudioStreamPlayer3D
var token = 0 # 一度だけ実行したいときに玉に用いるらしい

func trigger_entered(body: CharacterBody3D) -> void:
	if body == get_node("/root/" + get_tree().current_scene.name + "/Player") && token == 0:
		animationPlayer.play(anim_name)
		if scare_sound != null:
			scare_sound.play()
		#monitoring = false # Area3DのモニタリングがOFFだと、当たり判定無効になる -> 何かうまく機能しなかった
		token = 1
