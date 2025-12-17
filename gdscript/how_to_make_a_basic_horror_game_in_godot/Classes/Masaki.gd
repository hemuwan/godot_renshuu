'''
これが複数行のコメント
'''
class_name Masaki
extends Node
'''
スタテック変数はクラスから直接参照も、
インスタンスからみても(代入しても)同じ値になる。
参照が無くなってもアンロード、メモリ開放は行われない。
@static_unload を付ければ参照が無くなり次第開放される。
静的変数はデフォルトに戻る点に注意
'''
static var p = 1 
# スタティックでなければインスタンス毎に異なる。
var msg = "hei"

func msgprint():
	print(msg)
	
func change():
	msg = "masaki"
