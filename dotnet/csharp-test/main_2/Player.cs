using Godot;
using System;

public partial class Player : CharacterBody2D
{
	[Export]
	public float Speed {get;set;} = 200f;
	
	private Vector2 _targetPosition;
	private bool _moving = false;
	
	public override void _PhysicsProcess(double delta)
	{
		if (_moving)
		{
			Vector2 direction = (_targetPosition - GlobalPosition).Normalized();
			Velocity = direction * Speed;
			
			MoveAndSlide();
			
			if (GlobalPosition.DistanceTo(_targetPosition) < 5f)
			{
				_moving = false;
				Velocity = Vector2.Zero;
			}
		}
	}
	
	public void MoveTo(Vector2 position)
	{
		_targetPosition = position;
		_moving = true;
	}
}
