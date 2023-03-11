extends Node2D

var plain_start = preload("res://Scenes/LevelPieces/Plains/PlainStart.tscn")
var plain_end = preload("res://Scenes/LevelPieces/Plains/PlainEnd.tscn")
var plain_piece_1 = preload("res://Scenes/LevelPieces/Plains/Plain01.tscn")
var plain_piece_2 = preload("res://Scenes/LevelPieces/Plains/Plain02.tscn")

var pieces_plain = [plain_piece_1, plain_piece_2]

#export(int) var world_length
var rng = RandomNumberGenerator.new() 

func _ready():
	add_child(plain_start.instance())
	var position = Vector2(0 ,0)
	var piece 
	var world_length = instantiate()
	for i in range (world_length):
		piece = rand_piece()
		piece.position.x = (i+1)*16*64
		#piece.position.y = (i+1)*-64
		add_child(piece)
	var pe = plain_end.instance()
	position = Vector2((world_length + 1) * 16 * 64 , 0)
	pe.position = position
	add_child(pe)

func instantiate():
	rng.randomize()
	return rng.randi_range(1, 10)

func rand_piece():
	rng.randomize()
	return pieces_plain[rng.randi_range(0, pieces_plain.size() - 1)].instance()
