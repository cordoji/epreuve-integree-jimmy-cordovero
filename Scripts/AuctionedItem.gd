extends Panel

var url = "https://contralands.azurewebsites.net/"
var headers = ["Content-Type: application/json"]

var weapon_on_auction
var seller
var sellerid
var price
var description

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func refresh():
	$Line/Weapon/Visual/TextureRect.texture = weapon_on_auction.get_node("TextureRect").texture
	$Line/Price/Amount.text = str(price)
	$Line/Weapon/Description.text = description

func _on_Buy_pressed():
	if get_tree().root.get_node("Master").coins >= price:
		PlayerInventory.give_index(weapon_on_auction)
		PlayerInventory.add_weapon(weapon_on_auction, weapon_on_auction.index)
#		print(PlayerInventory.inventory)
		get_tree().root.get_node("Master/UserInterface/AuctionHouse").initialize_sellables()
		get_tree().root.get_node("Master").coins -= price
		get_tree().root.get_node("Master/CurrentScene/Base/HUD").refresh()
		
		var data_to_send = {"weaponid":weapon_on_auction.weaponid,
							"buyerid":get_tree().root.get_node("Master").userid,
							"sellerid":sellerid,
							"owner_username":get_tree().root.get_node("Master").username,
							"price":int(price),
							"index":weapon_on_auction.index}
		_make_post_request(url, "sell", data_to_send, true)
		self.visible = false
	else:
		$AcceptDialog.popup_centered()

func _make_post_request(url, method, data_to_send, use_ssl):
	var query = JSON.print(data_to_send)
	$HTTPRequest.request(url + method, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	print("test")
	if json.result == null:
		var data_to_send = {"username" : get_tree().root.get_node("Master").username }
		_make_post_request(url, "user", data_to_send, true)
	else:
		get_tree().root.get_node("Master").coins = json.result.coins
		get_tree().root.get_node("Master").emit_signal("coin_collected", json.result.coins)
	self.queue_free()

