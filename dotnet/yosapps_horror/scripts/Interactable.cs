using Godot;
using System;
using System.Runtime.CompilerServices;

// やっぱり、ファイル名とクラス名は一致する必要があるかも。
public partial class Interactable : StaticBody3D
{
	public enum ObjectType
	{
		Item,
		Look,
	}

	[Export]
	string ObjectName = "";
	[Export]
	public ObjectType CurrentType;
	[Export(PropertyHint.MultilineText)]
	string description = "";
	[Export(PropertyHint.MultilineText)]
	string DialogPlayer = "";

	public bool Rotating = false;
	public bool Looking = false;
	Vector2 PrevMousePosition;
	Vector2 NextMousePosition;
	Vector3 PrevPosition;
	Vector3 PrevRotation;

	public override void _PhysicsProcess(double delta)
	{
		// Godot4 から delta は double型に。
		// RotateX とかがfloat 引数なのでよく使うであろう float型delta を作っておく。
		// キャストの負荷が大きいとかある場合は都度キャストしないといけないかも
		float fDelta = (float)delta;
		if (Input.IsActionJustPressed("look") && CurrentType == ObjectType.Look)
		{
			// 右クリックしてObjectが「見る」だった場合、マウスの位置と回転中の変数を更新
			// シーンじゃなくてmain の方で変えとかないといけないよ
			Rotating = true;
			PrevMousePosition = GetViewport().GetMousePosition(); // Vec2
		}
		
		if (Input.IsActionJustReleased("look") && CurrentType == ObjectType.Look)
		{
			Rotating = false;
		}

		if (Rotating) {
			// 回転の変数がtreu の場合はマウスの位置を前のマウスの位置で
			// オブジェクトの回転の処理をする
			// double float 計算は暗黙的にキャストされるらしいけど、
			// 数字を直接各場合は f　つけないといけないかな
			// double a = 0.05;float b = (float)a - 1.0f;
			float RotateSpeed = 0.05f;
			NextMousePosition = GetViewport().GetMousePosition();
			RotateY((NextMousePosition.X - PrevMousePosition.X) * RotateSpeed * fDelta);
			RotateZ(-(NextMousePosition.Y - PrevMousePosition.Y) * RotateSpeed * fDelta);
			RotateX((NextMousePosition.Y - PrevMousePosition.Y) * RotateSpeed * fDelta);
		}
	}

	public void LookObject()
	{
		// 「見る」の時にクリックするとオブジェクトの元の位置を記録して近づける。
		Looking = true;
		PrevPosition = GlobalPosition;
		PrevRotation = GlobalRotation;
		// 「見る」状態のときは全体をポーズ状態にして、他のものが動かないように
		Input.MouseMode = Input.MouseModeEnum.Visible; // マウスは見えるように
		GetTree().Paused = true; // 他のスクリプトも止まっちゃうが。。process Always のものはとまらないっぽい
		// object RayCast3D はAlwaysにしている。スクリプトはどうしたらよいか。。。
		// カメラの前の位置となるノードを作る
		GlobalPosition = GetNode<Node3D>("/root/Main/Player/Head/Look").GlobalPosition;
	}

	public void ReturnObject()
	{
		// 近づけたオブジェクトを元の場所に戻す。ポーズも解除
		Looking = false;
		GlobalPosition = PrevPosition;
		GlobalRotation = PrevRotation;
		Input.MouseMode = Input.MouseModeEnum.Captured;
		GetTree().Paused = false;
	}
}
