extends Control

var url = "https://contralands.azurewebsites.net/"
var headers = ["Content-Type: application/json"]

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_SignIn_pressed():
	$Buttons.visible = false
	$LoginForm.visible = true

func _on_Register_pressed():
	$Buttons.visible = false
	$ConfirmGroup.visible = true

func _on_Cancel_pressed():
#	register_p = false
	$Buttons.visible = true
	$ConfirmGroup.visible = false

func _on_CancelB_pressed():
#	login_p = false
	$Buttons.visible = true
	$LoginForm.visible = false

func _on_Confirm_pressed():
#	register_p = true
	if $ConfirmGroup/PasswordC.text != $ConfirmGroup/PwConfirm.text:
		$Popup.dialog_text = "Please enter the same password!"
		$Popup.popup_centered()
		return
	
	$Popup.dialog_text = "This username is already taken"
	var data_to_send = { "username" : $ConfirmGroup/UserNameC.text , "password" : $ConfirmGroup/PasswordC.text  }
	_make_post_request(url, "adduser", data_to_send, true)

func _on_LoginB_pressed():
#	login_p = true
	$Popup.dialog_text = "That User/Password combination doesn't exist"
	var data_to_send = { "username" : $LoginForm/UserName.text, "password" : $LoginForm/Password.text }
	_make_post_request(url, "login", data_to_send, true)

func _make_post_request(url, method, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	
	$HTTPRequest.request(url + method, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_request_completed(result, response_code, headers, body):
	print(body.get_string_from_utf8())
	if body.get_string_from_utf8().empty():
		$Popup.popup_centered()
	else:
		self.visible = false
		var json = JSON.parse(body.get_string_from_utf8())
		get_tree().root.get_node("Master").username = json.result.username
