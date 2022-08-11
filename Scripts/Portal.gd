extends Area2D

export(PackedScene) var target_scene

var open = false

func _input(event):
	if event.is_action_pressed("ui_accept") and open:
		if !target_scene:
			print("no scene in this door")
			return
#		if get_overlapping_bodies().size() > 0:
		next_level()

func next_level():
	var ERR = get_tree().change_scene_to(target_scene)
	
	if ERR != OK:
		print("something failed in the door scene")

#func _on_Portal_input_event(viewport, event, shape_idx):
#	if event.is_action_pressed("ui_accept"):
#		next_level()


func _on_Portal_body_entered(body):
	open = true


func _on_Portal_body_exited(body):
	open = false
