using Godot;
using System;
using System.Security.Cryptography;
using System.Text;

public partial class Main : Control
{
	private string containerPath = "MarginContainer/HBoxContainer/";
	// セミコロンはコンパイルエラー
	// C#とはいえ、Godotのお作法に乗っ取らないといけない、処理を実行するなら _Ready, _Process とか
	public override void _Ready()
	{
		//GD.Print("hello"); // '' は char型、"" は文字列型
		//GetNode<Button>(containerPath + "HashButton").Pressed += OnHashButtonPressed;
		GetNode<Button>(containerPath + "HashButton").Pressed += void () =>　{ // こんな書き方もできた
			var inputText = GetNode<LineEdit>(containerPath + "InputField").Text;
			var hashed = ComputeSha256Hash(inputText);
			GetNode<Label>(containerPath + "ResultLabel").Text = $"ハッシュ：{hashed}";
		}; // 即時関数なのでセミコロンがいる
	}
	
	//private void OnHashButtonPressed()
	//{
		//var inputText = GetNode<LineEdit>(containerPath + "InputField").Text;
		//var hashed = ComputeSha256Hash(inputText);
		//GetNode<Label>(containerPath + "ResultLabel").Text = $"ハッシュ：{hashed}";
	//}
	
	private string ComputeSha256Hash(string rawData)
	{
		using var sha256 = SHA256.Create();
		var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(rawData));
		var builder = new StringBuilder();
		foreach(var b in bytes)
			builder.Append(b.ToString("x2")); // 16進数文字列に変換
		return builder.ToString();
	}
}
