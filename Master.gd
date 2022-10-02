extends Node2D

signal coin_collected

var titleMenu_scene = preload("res://Scenes/TitleMenu.tscn")
var level1_scene = preload("res://Scenes/Level1.tscn")
var base_scene = preload("res://Scenes/Base.tscn")
var weapon_scene = preload("res://Scenes/Weapon.tscn")

var url = "https://contralands.azurewebsites.net/"
var headers = ["Content-Type: application/json"]

var username
var userid
var coins = 0
var all_initiated = false

var current_scene
var next_scene

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	var titleMenu = titleMenu_scene.instance()
	current_scene = titleMenu
	get_tree().root.get_node("Master/CurrentScene").call_deferred("add_child", titleMenu)

func init_all():
	var data_to_send = { "owner_username" : get_tree().root.get_node("Master").username }
	_make_post_request(url, "all", data_to_send, true)

func init_auction_house():
	_make_get_request(url, "auctioned", true)

func _make_post_request(url, method, data_to_send, use_ssl):
	var query = JSON.print(data_to_send)
	$HTTPRequest.request(url + method, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _make_get_request(url, method, use_ssl):
	$HTTPRequest.request(url + method, headers, use_ssl, HTTPClient.METHOD_GET)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var weapon
	var prices = []
	for i in range (json.result.size()):
		weapon = weapon_scene.instance()
		weapon.init_weapon(json.result[i].id, json.result[i].name, json.result[i].damage, json.result[i].rof)
		match json.result[i].location:
			"inventory":
				PlayerInventory.inventory[int(json.result[i].index)] = [weapon]
			"equipment":
				PlayerInventory.equips[int(json.result[i].index)] = [weapon]
				if (int(json.result[i].index) == 0):
					PlayerInventory.current_weapon = weapon
			"auction_house":
				$UserInterface/AuctionHouse.sellList[$UserInterface/AuctionHouse.sellList.size()] = [weapon, json.result[i].price, json.result[i].owner, json.result[i].ownerid]
	$UserInterface/Inventory.initialize_equips()
	$UserInterface/AuctionHouse.initialize_auction_house()
#	print($UserInterface/AuctionHouse.sellList)
	if(!all_initiated):
		all_initiated = true
		init_auction_house()

func add_coin():
	coins += 1
	emit_signal("coin_collected", int(coins) + 1)
#func provide_level(nl):
#	match(nl):
#		"base_scene":
#			return base_scene
#		"level1_scene":
#			return level1_scene


