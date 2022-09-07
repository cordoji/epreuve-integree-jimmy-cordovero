extends Area2D


func _ready():
	pass


func _on_PC_body_entered(body):
	get_tree().root.get_node("Master/UserInterface").auctionHouse = true


func _on_PC_body_exited(body):
	get_tree().root.get_node("Master/UserInterface").auctionHouse = false
