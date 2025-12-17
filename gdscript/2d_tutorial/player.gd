extends Area2D
signal hit # 自作のシグナル

# export はインスペクタ側の値が優先される
@export var speed := 400 # 動く速さ
var screen_size: Vector2 # ゲームウィンドウサイズ

func _ready() -> void:
	screen_size = get_viewport_rect().size;
	hide(); # プレイヤーを隠す
	
func _process(delta: float) -> void:
	var velocity := Vector2.ZERO; # プレイヤーの移動方向を格納する
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	# 下右同時押すと(1,1) となり、normalized で正規化。適切な速さを保つ
	# https://docs.godotengine.org/ja/4.x/tutorials/math/vector_math.html#normalization
	# ベクトルを正規化する1ということは、方向を維持しながら長さを に減らすことを意味します。
	# $ は get_node() の省略形 get_node("AnimatedSprite2D").play();
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
		$AnimatedSprite2D.play();
	else: 
		$AnimatedSprite2D
		
	# クランプ→値を特定の範囲で制限
	position += velocity * delta;
	position = position.clamp(Vector2.ZERO, screen_size);
	
	# 方向からスプライトを指定
	# 同時入力時、上下の反転が無いので必ず立っている姿に。
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk";
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0; # 反転させている
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up";
		$AnimatedSprite2D.flip_v = velocity.y > 0;

func _on_body_entered(body) -> void:
	hide(); # 当たってるときはプレイヤー非表示,hit シグナルが複数回でないように
	hit.emit();
	# 物理コールバックで物理特性を変更できないため、延期する必要
	# エリアのコリジョン形状を無効にすると、それがエンジンの衝突処理の途中だったときにエラーが発生する可能性があります。
	# set_deferred() を使用すると、安全にシェイプを無効にできるようになるまでGodotを待機させることができます。
	$CollisionShape2D.set_deferred("disabled", true);

# 新しいゲーム開始時にPlayerをリセットするため、呼び出す関数
func start(pos):
	position = pos;
	show();
	$CollisionShape2D.disabled = false;
