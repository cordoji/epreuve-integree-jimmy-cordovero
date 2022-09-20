extends ConfirmationDialog

signal item_auctioned

var price

func _ready():
	get_ok().disabled = true


func _on_SellWindow_confirmed():
	price = int($VBoxContainer/HBoxContainer2/SpinBox.get_line_edit().text)
	if price > 0:
		emit_signal("item_auctioned")
	$VBoxContainer/HBoxContainer2/SpinBox.get_line_edit().text = "0"


func _on_SpinBox_gui_input(_event):
	if int($VBoxContainer/HBoxContainer2/SpinBox.get_line_edit().text) > 0:
		get_ok().disabled = false
