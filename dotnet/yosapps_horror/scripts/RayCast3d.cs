using Godot;
using System;

public partial class RayCast3d : RayCast3D
{
	// Player.cs で処理書いてたら GetTree().Paused = true;から逃れられなかったので、ファイル分け
	private Label PointerLabel;
	private Interactable PickupItem = null;

	public override void _Ready()
	{
		PointerLabel = GetNode<Label>("../../Pointer");
	}

  // Called every frame. 'delta' is the elapsed time since the previous frame.
  public override void _Process(double delta)
	{
		float fDelta = (float)delta;
		// RayCastが触れているかどうか
		if (IsColliding())
		{
			// RayCast3D detected =GetCollider(); 
			if (GetCollider() is Interactable i)
			{
				if (i.CurrentType == Interactable.ObjectType.Item)
				{
					PickupItem = i;
					PointerLabel.Text = "ひろう";
				}
				else if (i.CurrentType == Interactable.ObjectType.Look)
				{
					PickupItem = i;
					if (!PickupItem.Looking)
					{
						PointerLabel.Text = "みる";
					}
				}
			}
			else if (GetCollider() is Door door)
			{
				if (Input.IsActionJustPressed("pickup")) GD.Print("Door");
				door.RotateY(90f * 0.05f * fDelta);
			}
			else
			{
				PointerLabel.Text = "・";
				PickupItem = null;
			}
		}
		else
		{
			PointerLabel.Text = "・";
			PickupItem = null;
		}

		// item に注目しているときに左クリックで拾う
		if (PickupItem != null && Input.IsActionJustPressed("pickup"))
		{
			GD.Print(PickupItem);
			switch(PickupItem.CurrentType)
			{
				case Interactable.ObjectType.Item:
					PickupItem.QueueFree();
					PickupItem = null;
					GD.Print("ひろったよ");
					break;
				case Interactable.ObjectType.Look:
					GD.Print(4);
					if (PickupItem.Looking)
					{
						GD.Print(2);
						PickupItem.ReturnObject();
					}
					else
					{
						PointerLabel.Text = "";
						PickupItem.LookObject();
					}
					break;
			}
		}
	}
}
