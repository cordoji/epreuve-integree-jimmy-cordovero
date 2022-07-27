extends CanvasLayer

func _input(event):
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
		get_tree().paused = !get_tree().paused
		
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_weapon_scroll_up()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_weapon_scroll_down()

func _ready():
	pass
