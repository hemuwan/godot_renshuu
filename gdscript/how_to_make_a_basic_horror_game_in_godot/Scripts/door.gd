extends StaticBody3D

var interactable = true
var opened = false

func enemy_interact() -> void:
	if opened == false:
		opened = true;
		$open.play()
		$AnimationPlayer.play("open")
		# まだ動画途中

func interact():
	# シーン内のキーを取得すると、queue_free() でノードが消える = door の変数に登録したノードがnull になる
	# インスペクター上のインスタンスのkeyを インスペクター上のドアの件数に割り当てることで、複製も可能になる
	if get_parent().get_parent().locked == true && get_parent().get_parent().key == null:
		$locked.play()
		get_parent().get_parent().locked = false
	if interactable == true && get_parent().get_parent().locked == false:
		interactable = false
		opened = !opened
		if opened == false:
			$AnimationPlayer.play("close")
			await get_tree().create_timer(0.9,false).timeout # 音が閉まった瞬間の音なので動きに合わせて鳴らす
			$colse.play()
		if opened == true:
			$open.play()
			$AnimationPlayer.play("open")
		await get_tree().create_timer(1.0, false).timeout
		interactable = true
	if interactable == true && get_parent().get_parent().locked == true:
		interactable = false
		$locked.play()
		$AnimationPlayer.play("locked")
		await get_tree().create_timer(0.7, false).timeout
		interactable = true
