extends CanvasLayer

var item_name = "Godot"
var category = "Game"
var url = "https://contralands.azurewebsites.net/addTask"

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_Button_pressed():
	var data_to_send = { "name" : item_name , "category" : category  }
#	$HTTPRequest.request("https://contralands.azurewebsites.net/all")
	_make_post_request(url, data_to_send, true)
	


func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
#	print(body.get_string_from_utf8())

func _make_post_request(url, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
	print(data_to_send)


func _on_Button2_pressed():
	$HTTPRequest.request("https://contralands.azurewebsites.net/all")
