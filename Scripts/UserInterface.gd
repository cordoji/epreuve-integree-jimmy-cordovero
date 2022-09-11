extends CanvasLayer

var auctionHouse = false

func _input(event):
	if event.is_action_pressed("inventory") and !$AuctionHouse.visible:
		$Inventory.visible = !$Inventory.visible
		$AuctionHouse.reset_sellables()
		$Inventory.initialize_inventory()
		$Inventory.initialize_equips()
		get_tree().paused = !get_tree().paused
	
	if event.is_action_pressed("ui_accept") and auctionHouse and !$Inventory.visible:
		$AuctionHouse.visible = !$AuctionHouse.visible
		$Inventory.reset_inventory()
		$AuctionHouse.initialize_sellables()
		get_tree().paused = !get_tree().paused
	
	if event.is_action_pressed("ui_cancel") and $Inventory.visible == true:
		$Inventory.visible = !$Inventory.visible
		get_tree().paused = !get_tree().paused
	
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_weapon_scroll_up()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_weapon_scroll_down()

func _ready():
	pass
