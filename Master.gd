extends Node2D

var titleMenu_scene = preload("res://Scenes/TitleMenu.tscn")
var level1_scene = preload("res://Scenes/Level1.tscn")
var base_scene = preload("res://Scenes/Base.tscn")

var current_scene
var next_scene

func _ready():
	var titleMenu = titleMenu_scene.instance()
	current_scene = titleMenu
	get_tree().root.get_node("Master/CurrentScene").call_deferred("add_child", titleMenu)

#func provide_level(nl):
#	match(nl):
#		"base_scene":
#			return base_scene
#		"level1_scene":
#			return level1_scene


