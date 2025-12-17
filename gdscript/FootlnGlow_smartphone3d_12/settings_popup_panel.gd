extends PopupPanel

func open():
	# popup は Node/process/Mode を always にしとかないと同時に動かせなくなる
	print(self)
	#print(self.process_mode) # always -> 3 配列のindex かな
	#self.process_mode = Node.PROCESS_MODE_ALWAYS # これで変更できる
	#print(self.process_mode)
	#print(self.process_priority)
	#print(self.position.x)
	# 自身の取得は self 子ノードの取得は $<子ノード名>/<子ノード名>。。。
	get_tree().paused = true
	popup_centered()

func _on_h_slider_drag_ended(value_changed):
	var label: Label = $controlBaseSize/VBoxContainer/MarginContainer/Label
	var slider: HSlider = $controlBaseSize/VBoxContainer/MarginContainer2/HSlider
	label.text = "発射間隔　%.1f秒" % slider.value

func _on_button_pressed():
	# snake で登録したファイルがUppaerCamel で読み取れる？？
	# 登録名あるわ。
	GlobalSetting.m_firing_timing_sec = $controlBaseSize/VBoxContainer/MarginContainer2/HSlider.value
	GlobalSetting.save()
	hide()

func _on_popup_hide():
	get_tree().paused = false
