extends Node
class_name Counter # 親クラスはノードにアタッチしなくても使える

signal change_count(new_count)

static var count: int = 0:
	set(value):
		count = value
	get: return count
