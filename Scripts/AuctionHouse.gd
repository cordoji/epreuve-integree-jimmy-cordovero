extends Node2D


func _ready():
	pass


func _on_Sell_toggled(button_pressed):
	$GridContainer.visible = !$GridContainer.visible


func _on_AuctionHouse_body_entered(body):
	get_tree().root.get_node("Master/UserInterface").auctionHouse = true


func _on_AuctionHouse_body_exited(body):
	get_tree().root.get_node("Master/UserInterface").auctionHouse = false
