extends Area2D

export(PackedScene) var target_scene
#var level1_scene = preload("res://Scenes/Level1.tscn")

var open = false

func ready():
	if target_scene == null:
		generate_level()
		

func _input(event):
	if event.is_action_pressed("ui_accept") and open:
		if !target_scene:
			print("no scene in this door")
			return
#		if get_overlapping_bodies().size() > 0:
		next_level()

func next_level():
	var currentScene = get_tree().root.get_node("Master").current_scene
	get_tree().root.get_node("Master/CurrentScene").call_deferred("remove_child", currentScene)
	var ERR = get_tree().root.get_node("Master/CurrentScene").call_deferred("add_child", target_scene.instance())
	get_tree().root.get_node("Master").current_scene = target_scene
#	var ERR = get_tree().change_scene_to(target_scene.instance())

	if ERR != OK:
		print("something failed in the door scene")

#func _on_Portal_input_event(viewport, event, shape_idx):
#	if event.is_action_pressed("ui_accept"):
#		next_level()


func _on_Portal_body_entered(body):
	if body is KinematicBody2D:
		open = true


func _on_Portal_body_exited(body):
	if body is KinematicBody2D:
		open = false


static func _delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func generate_level():
#	target_scene = ...
	pass
