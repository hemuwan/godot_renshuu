using Godot;
using System;

public partial class Label : Godot.Label
{
	public override void _Ready()
	{
		// デフォルトで子要素をみるから同階層は ../ つける。右辺で型が明らかな場合はvarで宣言
		// プロパティにアクセスしたい場合、キャスト、as注釈、ジェネリクスのいずれかをする必要がある。
		// Button btn = (Button)GetNode("../Button"); // 明示的にキャストする方法
		// Button btn = GetNode("../Button") as Button; // as 注釈
		Button btn = GetNode<Button>($"../HashButton"); // ジェネリクス、推奨
		btn.MySignal += con;
		
		btn.Pressed += void () => 
		{
			Text = "pushed";
		};
	}
	
	private void con()
	{
		GD.Print("con");
	}
}
