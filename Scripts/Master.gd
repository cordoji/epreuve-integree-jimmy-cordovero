extends Node2D

signal coin_collected

var titleMenu_scene = preload("res://Scenes/TitleMenu.tscn")
var level1_scene = preload("res://Scenes/Level1.tscn")
var base_scene = preload("res://Scenes/Base.tscn")
var weapon_scene = preload("res://Scenes/Weapon.tscn")
var world_generator_scene = preload("res://Scenes/World_generator.tscn")

var url = "https://contralands.azurewebsites.net/"
var headers = ["Content-Type: application/json"]

var username
var userid
var coins = 0
var coins_pu = 0
var all_initiated = false

var current_scene
var next_scene

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$RefreshCoins.connect("request_completed", self, "_refresh_coins")
	var titleMenu = titleMenu_scene.instance()
	current_scene = titleMenu
	$CurrentScene.call_deferred("add_child", titleMenu)

func init_all():
	var data_to_send = { "owner_username" : username }
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
	var sellListSize
	var j = json.result
	for i in range (j.size()):
		weapon = weapon_scene.instance()
		weapon.init_weapon(j[i].id, j[i].name, j[i].damage, j[i].rof)
		match json.result[i].location:
			"inventory":
				PlayerInventory.inventory[int(j[i].index)] = [weapon]
			"equipment":
				PlayerInventory.equips[int(j[i].index)] = [weapon]
				if (int(j[i].index) == 0):
					PlayerInventory.current_weapon = weapon
			"auction_house":
				sellListSize = $UserInterface/AuctionHouse.sellList.size()
				$UserInterface/AuctionHouse.sellList[sellListSize] = [weapon, j[i].price, j[i].owner, j[i].ownerid]
	$UserInterface/Inventory.initialize_equips()
	$UserInterface/AuctionHouse.initialize_auction_house()
	if(!all_initiated):
		all_initiated = true
		init_auction_house()

func add_coin():
	$Timer.start()
	coins_pu += 1
	emit_signal("coin_collected", coins + coins_pu)
	
#func provide_level(nl):
#	match(nl):
#		"base_scene":
#			return base_scene
#		"level1_scene":
#			return level1_scene

func _on_Timer_timeout():
	var data_to_send = {"username" : username}
	request_coins(url, "user", data_to_send, true)

func request_coins(url, method, data_to_send, use_ssl):
	var query = JSON.print(data_to_send)
	$RefreshCoins.request(url + method, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _refresh_coins(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var diff_db = json.result.coins - coins
	coins = coins + diff_db + coins_pu
	emit_signal("coin_collected", coins)
	if diff_db != 0 or coins_pu != 0:
		coins_pu = 0
		var data_to_send = { "id" : userid, "coins" : coins}
		request_coins(url, "addcoin", data_to_send, true)
	
