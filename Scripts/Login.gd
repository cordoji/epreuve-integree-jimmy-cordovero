extends Control

var url = "https://contralands.azurewebsites.net/"
var headers = ["Content-Type: application/json"]
var regex_user = RegEx.new()
var regex_pwd = RegEx.new()


func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	regex_pwd.compile("(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,12}")
	regex_user.compile("(?=.*[A-Za-z])(?=.*\\d)|[A-Za-z\\d]{6,12}")

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
	if (regex_user.search($ConfirmGroup/UserNameC.text) == null 
		or regex_user.search($ConfirmGroup/UserNameC.text).get_string() != $ConfirmGroup/UserNameC.text):
		$Popup.dialog_text = "User must contain between 6 and 12 alphanumerical characters"
		$Popup.popup_centered()
		return
	
	if (regex_pwd.search($ConfirmGroup/PasswordC.text) == null
		or regex_pwd.search($ConfirmGroup/PasswordC.text).get_string() != $ConfirmGroup/PasswordC.text):
		$Popup.dialog_text = "Password must contain minimum 8 characters, maximum 12 characters, at least one letter, one number and one special character"
		$Popup.popup_centered()
		return
	
	if $ConfirmGroup/PasswordC.text != $ConfirmGroup/PwConfirm.text:
		$Popup.dialog_text = "Please enter the same password!"
		$Popup.popup_centered()
		return
	
	$Popup.dialog_text = "This username is already taken"
	var data_to_send = {"username" : $ConfirmGroup/UserNameC.text, 
						"password" : $ConfirmGroup/PasswordC.text, 
						"coins" : 100}
	_make_post_request(url, "adduser", data_to_send, true)

func _on_LoginB_pressed():
	$Popup.dialog_text = "That User/Password combination doesn't exist"
	var data_to_send = {"username" : $LoginForm/UserName.text, 
						"password" : $LoginForm/Password.text}
	_make_post_request(url, "login", data_to_send, true)

func _make_post_request(url, method, data_to_send, use_ssl):
	var query = JSON.print(data_to_send)
	$HTTPRequest.request(url + method, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if body.get_string_from_utf8().empty() or json.result == null:
		$Popup.popup_centered()
	else:
		self.visible = false
		get_tree().root.get_node("Master").username = json.result.username
		get_tree().root.get_node("Master").userid = json.result.id
		get_tree().root.get_node("Master").coins = int(json.result.coins)
