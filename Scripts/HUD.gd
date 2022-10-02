extends CanvasLayer

func _ready():
	get_tree().root.get_node("Master").connect("coin_collected",self,"_on_coin_collected")
	$Coins.text = String(get_tree().root.get_node("Master").coins)

func _physics_process(_delta):
	pass

func refresh():
	$Coins.text = String(get_tree().root.get_node("Master").coins)

func _on_coin_collected():
	refresh()
#	if coins == 10000:
#		get_tree().change_scene("res://Scenes/GameWon.tscn")


