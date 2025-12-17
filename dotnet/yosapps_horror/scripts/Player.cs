using Godot;
using System;

public partial class Player : CharacterBody3D
{
	// 各子ノード取得のため宣言
	private Node3D HeadCamera;
	private SpotLight3D HeadLight;

	[Export]
	private float Speed = 5.0f;
	[Export]
	private float DashSpeed = 10.0f;
	private const float JumpVelocity = 4.5f;
	private float MoveSpeed;
	[Export]
	private float sens = 0.005f;

	public override void _Ready()
	{
		// Input.MouseMode = Input.MouseModeEnum.Captured; // マウスカーソルを消す
		HeadCamera = GetNode<Node3D>("Head"); // カメラ捜査のため子ノード取得
		HeadLight = GetNode<SpotLight3D>("./Head/SpotLight3D");
		MoveSpeed = Speed; // 変数の値など動的なものを入れるにはReady内で初期化?
		GD.Print("herrrrrrrrrrri");
	}
	
	public override void _Input(InputEvent @event)
	{
		if (@event is InputEventMouseMotion eventMouseMotion)
		{
			// Head のスクリプトから移植。
			// 縦回転はHead要素のX軸を回転
			// 横回転は親要素のY軸を回転させる。そうしないとずれていく
			RotateY(-eventMouseMotion.Relative.X * sens);
			HeadCamera.RotateX(-eventMouseMotion.Relative.Y * sens);
			// 一回変数に入れないといけない？ Rotation.X はエラーになる。
			// C# に deg_to_rad と同等の機能の関数はないらしい?あるやんけ。
			// これは何のためにしているんだ？
			Vector3 currentRotaion = HeadCamera.Rotation;
			currentRotaion.X = Mathf.Clamp(
				Rotation.X,
				Mathf.DegToRad(-90),
				Mathf.DegToRad(90)
			);
		}
	}

	public override void _Process(double delta)
	{
		// F キー押したらライト点け消し
		if (Input.IsActionJustPressed("flashlight"))
		{
			HeadCamera.Visible = !HeadCamera.Visible;
		}
	}

  public override void _PhysicsProcess(double delta)
	{
		Vector3 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * (float)delta;
		}

		// Handle Jump.
		if (Input.IsActionJustPressed("jump") && IsOnFloor())
		{
			velocity.Y = JumpVelocity;
		}

		// Get the input direction and handle the movement/deceleration.
		// As good practice, you should replace UI actions with custom gameplay actions.
		Vector2 inputDir = Input.GetVector("left", "right", "up", "down");
		Vector3 direction = (Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();

		// 先にチェックしないと、シフト押してからだと走れなくなる。
		if (Input.IsActionJustPressed("dash"))
		{
			MoveSpeed = DashSpeed;
		}
		else if (Input.IsActionJustReleased("dash"))
		{
			MoveSpeed = Speed;
		}
		// 単なる値の代入なら三項演算子のほうがelseif で条件判定するよりわずかに効率的（ほぼわからない程度
		// すごい数のnew するとか、大きな配列をコピーするとか代入する際の他の操作で重くなることもある
		// JustPressed じゃなくて Pressed
		// MoveSpeed = Input.IsActionPressed("dash") ? DashSpeed : Speed;

		if (direction != Vector3.Zero)
		{
			velocity.X = direction.X * MoveSpeed;
			velocity.Z = direction.Z * MoveSpeed;
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, MoveSpeed);
			velocity.Z = Mathf.MoveToward(Velocity.Z, 0, MoveSpeed);
		}

		Velocity = velocity;
		MoveAndSlide();
	}
}
