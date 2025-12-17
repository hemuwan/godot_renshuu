extends SpotLight3D

var picked_up := false # ライトを拾うまでfalse
var firsttime := true
var flashlight_ui
var flashlight_energy
var drain_rate := 0.05

func _ready() -> void:
	flashlight_ui = get_node("/root/" + get_tree().current_scene.name + "/UI/flashlight_stuff")
	flashlight_energy = get_node("/root/" + get_tree().current_scene.name + "/UI/flashlight_stuff/flashlight_slider")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 初めてpickup がtruee になったときは自動でもち換えたい
	if firsttime && picked_up:
		visible = !visible
		flashlight_ui.visible = visible
		$toggle.play() # 子ノードのaudioStrem を再生
		firsttime = false
	
	if Input.is_action_just_pressed("flushlight") && picked_up == true && flashlight_energy.value > 0:
		# 懐中電灯のオンオフ
		visible = !visible
		flashlight_ui.visible = visible
		$toggle.play() # 子ノードのaudioStrem を再生
	if visible:
		flashlight_energy.value -= drain_rate * delta
	if flashlight_energy.value == 0 && visible == true:
		visible = false
		flashlight_ui.visible = false
