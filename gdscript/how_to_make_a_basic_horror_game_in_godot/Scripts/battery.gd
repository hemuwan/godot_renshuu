extends Node3D

const energy_add_amount := 0.5 # 半分の回復
@onready var flashlight_energy: Slider = get_node("/root/" + get_tree().current_scene.name + "/UI/flashlight_stuff/flashlight_slider")
@onready var pickup_sound: AudioStreamPlayer3D = get_node("/root/" + get_tree().current_scene.name + "/Sounds/obj_pickup")
@onready var flashlight: SpotLight3D = get_node("/root/" + get_tree().current_scene.name + "/Player/head/flashlight") # プレイヤーが持つ方のライト

func interact():
	# ライトを拾っていれば電池を拾える
	if flashlight.picked_up == true:
		flashlight_energy.value += energy_add_amount
		pickup_sound.play()
		queue_free()
