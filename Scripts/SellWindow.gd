extends ConfirmationDialog

signal item_auctioned

var url = "https://contralands.azurewebsites.net/"
var headers = ["Content-Type: application/json"]

var price

func _ready():
	get_ok().disabled = true
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _make_post_request(url, method, data_to_send, use_ssl):
	var query = JSON.print(data_to_send)
	$HTTPRequest.request(url + method, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)

func _on_SellWindow_confirmed():
	price = int($VBoxContainer/HBoxContainer2/SpinBox.get_line_edit().text)
	if price > 0:
		emit_signal("item_auctioned")
	$VBoxContainer/HBoxContainer2/SpinBox.get_line_edit().text = "0"
	
	var weaponid = get_tree().root.get_node("Master/UserInterface/AuctionHouse").selected_weapon.weaponid
	var data_to_send = {"id": weaponid, 
						"location" : "auction_house", 
						"price" : int(price), 
						"owner": get_tree().root.get_node("Master").username, 
						"ownerid" : get_tree().root.get_node("Master").userid}
	_make_post_request(url, "auction", data_to_send, true)


func _on_SpinBox_gui_input(_event):
	if int($VBoxContainer/HBoxContainer2/SpinBox.get_line_edit().text) > 0:
		get_ok().disabled = false
	else:
		get_ok().disabled = true


func _on_SellWindow_gui_input(event):
	if int($VBoxContainer/HBoxContainer2/SpinBox.get_line_edit().text) > 0:
		get_ok().disabled = false
	else:
		get_ok().disabled = true
