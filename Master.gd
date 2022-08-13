extends Node2D

var titleMenu_scene = preload("res://Scenes/TitleMenu.tscn")
var current_scene

func _ready():
	var titleMenu = titleMenu_scene.instance()
	current_scene = titleMenu
	get_tree().root.get_node("Master/CurrentScene").call_deferred("add_child", titleMenu)
