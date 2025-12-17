extends Node

var m_firing_timing_sec: float = 1.0

# windows で保存した場合は
# C:\Users......\AppData\Roaming\Godot\app_userdata\S23_GameSystem_008に「config.cfg」というファイルが生成されました。
# C:\Users\user\AppData\Roaming\Godot\app_userdata\FootlnGlow_smartphone3d_2 配下にできた　ゲーム消しても残った。
const M_FILE_NAME = "user://config.cfg"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Configファイル生成
	var config: ConfigFile = ConfigFile.new()
	# ファイルから読み出し
	var err := config.load(M_FILE_NAME)
	# エラーの場合修了（最初はファイルない）
	if err != OK:
		print("err")
		return
	# アクション"Player" のキー"firing_timing" に対する値を読み出す
	print("config ok")
	m_firing_timing_sec = config.get_value("Player", "firing_timing")

func save() -> void:
	# confing ファイル生成
	var config = ConfigFile.new()
	# セクション"Player" のキー"firing_timing" に対して、
	# m_firing_timing_sec を保存する
	config.set_value("Player", "firing_timing", m_firing_timing_sec)
	# ファイルに保存（上書き）
	config.save(M_FILE_NAME)
	
	
func _process(delta):
	pass
