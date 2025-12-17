extends  Counter

@onready var incrementButton: Button = $"../../Control/incrementButton";

func _ready() -> void:
	incrementButton.increment.connect(func() -> void:
		print("子クラスから increment が呼び出された")
		count = count + 1
		print("今のカウントは " + str(count))
		change_count.emit(count) # connect するのは emit を呼んだ子クラスノード
		print("emit したはず")
	)
