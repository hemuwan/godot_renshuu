extends Counter

@onready var decrement_btn: Button = $"../../Control/decrementButton";

# emit 側で値を送信する想定が出来てなくてハマった。
func _ready() -> void:
	decrement_btn.decrement.connect(func(value):
		print("子クラスから decrement が呼び出された")
		count = count - value
		print("今のカウントは " + str(count))
		change_count.emit(count) # connect するのは emit を呼んだ子クラスノード(親側にメソッドを定義していても同じ)
		print("emit したはず")	
	)

#func _ready() -> void:
	#decrement_btn.decrement.connect(decrement)
#
## 親でsattic にしていたら値を共有で切るっぽい
#func decrement(value: int):
	#print("子クラスから decrement が呼び出された")
	#count = count - value
	#print("今のカウントは " + str(count))
	#change_count.emit(count) # connect するのは emit を呼んだ子クラスノード(親側にメソッドを定義していても同じ)
	#print("emit したはず")
