extends Label

func _ready() -> void:
	# カウントが変更されたらそれを表示する。
	#$"../incrementer".change_count.connect(func(new_count):
	$"../incrementer".change_count.connect(func(new_count):
		# ずっと親クラスをconnect していた。。。
		print("カウントの変更シグナルを受け取ったよ")
		text = str(new_count)
	)
	$"../decrementer".change_count.connect(func(new_count): 
		print("decrement !")
		text = str(new_count)
	)
