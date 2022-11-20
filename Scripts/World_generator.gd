extends Node2D

var plain_scene = preload("res://Scenes/LevelPieces/Plains/PlainStart.tscn")
var plain_piece = preload("res://Scenes/LevelPieces/Plains/Plain1.tscn")

export(int) var world_length 

func _ready():
	add_child(plain_scene.instance())
	var position = Vector2(0 ,0)
	var piece 
	for i in range (world_length):
		piece = plain_piece.instance()
		piece.position.x = i*16*64
		add_child(piece)
