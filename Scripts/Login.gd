extends Control

var url = "https://contralands.azurewebsites.net/"
var headers = ["Content-Type: application/json"]

var last_request = null
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
	register_p = false
	$Buttons.visible = true
	$ConfirmGroup.visible = false

func _on_CancelB_pressed():
	login_p = false
	$Buttons.visible = true
	$LoginForm.visible = false

func _on_Confirm_pressed():
	register_p = true
	if $ConfirmGroup/PasswordC.text != $ConfirmGroup/PwConfirm.text:
		$Popup.dialog_text = "Please enter the same password!"
		$Popup.popup_centered()
		return
		
	var data_to_send = { "username" : $ConfirmGroup/UserNameC.text }
	_make_post_request(url + "user", data_to_send, true)

func _on_LoginB_pressed():
	login_p = true
	var data_to_send = { "username" : $LoginForm/UserName.text, "password" : $LoginForm/Password.text }
	_make_post_request(url + "login", data_to_send, true)

func _make_post_request(url, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_request_completed(result, response_code, headers, body):
	print(body.get_string_from_utf8())
	if body.get_string_from_utf8().length() > 3:
		var json = JSON.parse(body.get_string_from_utf8())
		last_request = json.result
	else:
		last_request = null
	
	if register_p:
		register_player()
	
	if login_p:
		login_player()

func register_player():
	register_p = false
	if last_request == null:
		var data_to_send = { "username" : $ConfirmGroup/UserNameC.text , "password" : $ConfirmGroup/PasswordC.text  }
		_make_post_request(url + "adduser", data_to_send, true)
		self.visible = false
	else:
		$Popup.dialog_text = "This username is already taken"
		$Popup.popup_centered()

func login_player():
	login_p = false
	if last_request != null:
		self.visible = false
		return
	$Popup.dialog_text = "That User/Password combination doesn't exist"
	$Popup.popup_centered()
	$HTTPRequest.queue_free()
