extends CanvasLayer

var coins = 1000

func _ready():
	$Coins.text = String(coins)

func _physics_process(_delta):
	pass

func refresh():
	_ready()

func _on_coin_collected():
	coins += 1
	_ready()
	if coins == 10000:
		get_tree().change_scene("res://Scenes/GameWon.tscn")
