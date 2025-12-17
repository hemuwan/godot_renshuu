using Godot;
using System;

public partial class Main : Node3D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		// エディターでは明るく、起動時に画面を暗くする。
		GetNode<WorldEnvironment>("./WorldEnvironment").Environment.BackgroundEnergyMultiplier = 0;
		
		// マウスカーソルを消す
		Input.MouseMode = Input.MouseModeEnum.Captured; 
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	// public override void _Process(double delta)
	// {
	// }
}
