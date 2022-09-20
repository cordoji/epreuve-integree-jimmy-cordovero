extends Control

var url = "https://contralands.azurewebsites.net/"
var last_request
var login_p = false
var register_p = false

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_SignIn_pressed():
	$Buttons.visible = false
	$LoginForm.visible = true

func _on_Register_pressed():
	$Buttons.visible = false
	$ConfirmGroup.visible = true

func _on_Cancel_pressed():
	$Buttons.visible = true
	$ConfirmGroup.visible = false

func _on_CancelB_pressed():
	$Buttons.visible = true
	$LoginForm.visible = false

func _on_Confirm_pressed():
	register_p = true
	if $ConfirmGroup/PasswordC.text != $ConfirmGroup/PwConfirm.text:
		$Popup.dialog_text = "Please enter the same password!"
		$Popup.popup_centered()
		return
	
	$HTTPRequest.request("https://contralands.azurewebsites.net/all")

func _on_LoginB_pressed():
	login_p = true
	$HTTPRequest.request("https://contralands.azurewebsites.net/all")

func _make_post_request(url, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	last_request = json.result
	
	if register_p:
		register_player()
	
	if login_p:
		login_player()

func register_player():
	register_p = false
	var duplicate = false
	for i in range(last_request.size()):
		if last_request[i].name == $ConfirmGroup/UserNameC.text:
			duplicate = true
	if !duplicate:
		var data_to_send = { "name" : $ConfirmGroup/UserNameC.text , "category" : $ConfirmGroup/PasswordC.text  }
		_make_post_request(url + "adduser", data_to_send, true)
		self.visible = false
	else:
		$Popup.dialog_text = "This username is already taken"
		$Popup.popup_centered()

func login_player():
	login_p = false
	for i in range(last_request.size()):
		if last_request[i].name == $LoginForm/UserName.text and last_request[i].category == $LoginForm/Password.text:
			self.visible = false
			return
	$Popup.dialog_text = "That User/Password combination doesn't exist"
	$Popup.popup_centered()
