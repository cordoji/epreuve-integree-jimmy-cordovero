extends Panel

var weapon_on_auction
var seller
var price
var description

func _ready():
	pass

func refresh():
	$Line/Weapon/Visual/TextureRect.texture = weapon_on_auction.get_node("TextureRect").texture
	$Line/Price/Amount.text = str(price)
	$Line/Weapon/Description.text = description

func _on_Buy_pressed():
	if get_tree().root.get_node("Master/CurrentScene/Base/HUD").coins > price:
		PlayerInventory.add_weapon(weapon_on_auction)
		print(PlayerInventory.inventory)
		get_tree().root.get_node("Master/UserInterface/AuctionHouse").initialize_sellables()
		get_tree().root.get_node("Master/CurrentScene/Base/HUD").coins -= price
		get_tree().root.get_node("Master/CurrentScene/Base/HUD").refresh()
		self.queue_free()
	else:
		$AcceptDialog.popup_centered()

