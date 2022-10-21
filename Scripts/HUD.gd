extends CanvasLayer

var coins

func _ready():
	get_tree().root.get_node("Master").connect("coin_collected",self,"_on_coin_collected")
	coins = get_tree().root.get_node("Master").coins
	$Coins.text = String(coins)

func _physics_process(_delta):
	pass

func refresh():
#	_ready()
	$Coins.text = str(coins)
#	print(str(get_tree().root.get_node("Master").coins))
#	pass

func _on_coin_collected(c):
	coins = c
	refresh()
#	if coins == 10000:
#		get_tree().change_scene("res://Scenes/GameWon.tscn")


