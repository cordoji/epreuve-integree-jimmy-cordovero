extends Area2D

var url = "https://contralands.azurewebsites.net/"
var headers = ["Content-Type: application/json"]

var projectile_scene = preload("res://Scenes/Projectile.tscn")

var weapon_name
var weapons_array = ["raygun", "raygunBig", "raygunPurple", "raygunPurpleBig"]

var damage_modifier
var fire_rate

var rng = RandomNumberGenerator.new()

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	rng.randomize()
	var number = rng.randi_range(0, weapons_array.size() - 1)
	weapon_name = weapons_array[number]
	damage_modifier = number + 1
	fire_rate = (number + 1)/2.0
	$Sprite.texture = load("res://Assets/Request pack (100 assets)/PNG/" + weapon_name + ".png")
#	print(damage_modifier)

func fire(origin, direction):
	if $Cooldown.is_stopped():
#		var origin = get_tree().root.get_node("Level1/Player").global_position
		var projectile = projectile_scene.instance()
		projectile_stats(projectile)
#		print(projectile.damage)
#		print($Cooldown.wait_time)
#		print(fire_rate)
		get_tree().root.add_child(projectile)
		projectile_in_scene(projectile, origin, direction)
		projectile.get_node("Sprite").texture = load("res://Assets/Request pack (100 assets)/PNG/laserRedHorizontal.png")
		$Cooldown.start()

func projectile_stats(projectile):
		projectile.damage *= damage_modifier
		$Cooldown.wait_time = fire_rate

func projectile_in_scene(projectile, origin, direction):
	projectile.global_position = origin
	var projectile_rotation = origin.direction_to(direction).angle()
	projectile.rotation = projectile_rotation

func _on_Weapon_body_entered(_body):
	var data_to_send = { "name" : weapon_name, "damage" : damage_modifier, "rof" : fire_rate, "owner" : "test" }
	_make_post_request(url + "addweapon", data_to_send, true)
#	print("test")
	PlayerInventory.add_weapon(self)
	$AnimationPlayer.play("Bounce")

func _spawn():
	get_node("TextureRect").visible = false
	get_node("Sprite").visible = true
	get_node("Sprite").scale = Vector2(2,2)
#	set_collision_layer_bit(0, true)
#	set_collision_mask_bit(0, true)

func _on_AnimationPlayer_animation_finished(_anim_name):
#	get_tree().root.get_node("Master/CurrentScene/Level1/Enemies").call_deferred("remove_child", self)
	set_collision_layer_bit(3, false)
	set_collision_mask_bit(0, false)
	self.visible = false
#	pass

func set_weapon(w):
	$TextureRect.texture = load("res://Assets/Request pack (100 assets)/PNG/" +  w.weapon_name + ".png")
	get_node("TextureRect").visible = true
	get_node("Sprite").visible = false

func _make_post_request(url, data_to_send, use_ssl):
	# Convert data to json string:
	var query = JSON.print(data_to_send)
	print(query)
	
	$HTTPRequest.request(url, headers, use_ssl, HTTPClient.METHOD_POST, query)
	print(url)

func _on_request_completed(result, response_code, headers, body):
	self.visible = true
	get_tree().root.get_node("Master/CurrentScene/Level1/Enemies").call_deferred("remove_child", self)
	print(body.get_string_from_utf8())
