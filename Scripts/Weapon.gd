extends Area2D

var weapon_name

func _ready():
	weapon_name = "raygun"

#func _ready():
#	if randi() % 2 == 0:
#		$TextureRect.texture = load("res://Assets/Request pack (100 assets)/PNG/raygun.png")
#	else:
#		$TextureRect.texture = load("res://Assets/Request pack (100 assets)/PNG/raygunPurple.png")

func _on_Weapon_body_entered(_body):
	PlayerInventory.add_weapon(weapon_name)
	$AnimationPlayer.play("Bounce")

func _spawn():
	get_node("TextureRect").visible = false
	get_node("Sprite").visible = true
	get_node("Sprite").scale = Vector2(2,2)
	#get_node("TextureRect").rect_position = Vector2(-70,-70)
	#$Timer.start()


func _on_Timer_timeout():
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

func set_weapon(nm):
	weapon_name = nm
	$TextureRect.texture = load("res://Assets/Request pack (100 assets)/PNG/" + weapon_name + ".png")
