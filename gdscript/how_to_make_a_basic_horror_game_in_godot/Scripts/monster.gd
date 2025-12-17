extends CharacterBody3D

var SPEED := 2
var jumpscareTimr := 2
var player: CharacterBody3D
var caught := false
var distance: float
@export var scene_name: String # death シーン
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") # プロジェクト設定と同じ値 -> 9.8

func _ready() -> void:
	player = get_node("/root/" + get_tree().current_scene.name + "/Player")
	
func _physics_process(delta: float) -> void:
	if visible:
		if not is_on_floor():
	#		# モンスターが表示されていて、床にいないときは落ちる
			velocity.y -= gravity * delta
		var current_location = global_transform.origin # 現在のグローバル位置を取得
		var next_location = $NavigationAgent3D.get_next_path_position() # 次の位置を取得
		var new_velocity = (next_location - current_location).normalized() * SPEED
		$NavigationAgent3D.set_velocity(new_velocity)
		
		# 進行方向に向く処理
		var look_dir = atan2(-velocity.x, -velocity.z)
		rotation.y = look_dir
		
		# プレイヤーとモンスターの間の距離を取得
		distance = player.global_transform.origin.distance_to(global_transform.origin)
		if distance <= 2 && caught == false:
			player.visible = false
			SPEED = 0
			caught = true
			$jumpscare_camera.current = true
			$jumpscare_light.visible = true
			if !$jumscare_sound.playing: # 再生中かどうか
				$jumscare_sound.play()
			await get_tree().create_timer(jumpscareTimr, false).timeout # false -> pause になってないときのみ一時停止
			get_tree().change_scene_to_file("res://Scenes/" + scene_name + ".tscn") # 死亡シーンなど

func update_target_location(target_location):
	# 向かいたい場所を入れると、そこまでナビゲーションしてくれるのか。追いかけるときにplayer とか
	$NavigationAgent3D.target_position = target_location
	
func on_navigation_agent_3d_velocity_computed(safe_velocity):
	# AIがものにぶつからないようにする
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
