extends CharacterBody3D

var ORIGINAL_SPEED
var SPEED = 3.0
var sprint_drain_amount = 0.3 # ダッシュ中の減少幅
var sprint_refresh_amount = 0.4 # ダッシュ解除時の回復幅
var SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 4.5
var sprint_slider
var movable = false # ムービー中などにfalse

func _ready() -> void:
	ORIGINAL_SPEED = SPEED
	# 現在のシーンのUIノードを取り出している。今の時点では /root/level/UI/sprint_slider になるかな
	sprint_slider = get_node("/root/" + get_tree().current_scene.name + "/UI/sprint_slider")

func _process(delta: float) -> void:
	if SPEED == SPRINT_SPEED:
		# ダッシュ中なら
		# UI/sprint_slider のstep が 0.01 だと全然下がらなかった　0.001 でうまくいった->結局 step 0 にした
		sprint_slider.value = sprint_slider.value - sprint_drain_amount * delta 
		if sprint_slider.value == sprint_slider.min_value:
			SPEED = ORIGINAL_SPEED
	elif SPEED != SPRINT_SPEED:
		if sprint_slider.value < sprint_slider.max_value:
			sprint_slider.value = sprint_slider.value + sprint_refresh_amount * delta
		if sprint_slider.value == sprint_slider.max_value:
			sprint_slider.visible = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		# デルタを書けることにより、フレームレートに依存せず、時間に依存する。
		velocity += get_gravity() * delta

	if movable == true:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("left", "right", "forward", "backward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED

			if Input.is_action_just_pressed("sprint"):
				sprint_slider.visible = true
				SPEED = SPRINT_SPEED
			if Input.is_action_just_released("sprint"):
				SPEED = ORIGINAL_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
