extends Button

#var level1_scene = preload("res://Scenes/Level1.tscn")

func _on_PlayButton_pressed():
#	get_tree().change_scene("res://Scenes/Level1.tscn")
#	var level1 = get_tree().root.get_node("Master").level1_scene.instance()
#	var currentScene = get_tree().root.get_node("Master").current_scene
#	get_tree().root.get_node("Master/CurrentScene").call_deferred("remove_child", currentScene)
#	get_tree().root.get_node("Master/CurrentScene").call_deferred("add_child", level1)
#	currentScene.queue_free()
#	get_tree().root.get_node("Master").current_scene = level1
#	get_tree().root.get_node("Master/UserInterface").inventory = true
#	print(get_tree().root.get_node("Master").username)
	$Timer.start()
	get_tree().root.get_node("Master").init_all()


func _on_Timer_timeout():
	var level1 = get_tree().root.get_node("Master").level1_scene.instance()
	var currentScene = get_tree().root.get_node("Master").current_scene
	get_tree().root.get_node("Master/CurrentScene").call_deferred("remove_child", currentScene)
	get_tree().root.get_node("Master/CurrentScene").call_deferred("add_child", level1)
	currentScene.queue_free()
	get_tree().root.get_node("Master").current_scene = level1
	get_tree().root.get_node("Master/UserInterface").inventory = true
