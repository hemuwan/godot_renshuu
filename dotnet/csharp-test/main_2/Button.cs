using Godot;
using System;

public partial class Button : Godot.Button
{
	[Signal]
	public delegate void MySignalEventHandler(); // 宣言するときだけ EventHandler を付けないといけない
		
	//	C＃の受信側メソッドは自動生成されないので書くしかない。
	private void _on_pressed()
	{
		GD.Print("hei");
		EmitSignal(SignalName.MySignal);
		GD.Print("hoi");
	}
}
