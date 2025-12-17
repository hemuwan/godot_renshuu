using Godot;
using System;

public partial class Main2 : Node2D
{
	[Export]
	public Player Player;
	
	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed)
		{
			Vector2 clickPos = GetGlobalMousePosition();
			Player.MoveTo(clickPos);
		}
	}
}
