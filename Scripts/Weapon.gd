extends Area2D

var url = "https://contralands.azurewebsites.net/"
var headers = ["Content-Type: application/json"]

var projectile_scene = preload("res://Scenes/Projectile.tscn")

var rng = RandomNumberGenerator.new()

var weapons_array = ["raygun", "raygunBig", "raygunPurple", "raygunPurpleBig"]

var weapon_name
var damage_modifier
var fire_rate

var weaponid
var index
var owner_username

var to_inventory = false
var instantiated = false
var pickable = false



func _ready():
	owner_username = get_tree().root.get_node("Master").username
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func instantiate():
	pickable = true
	rng.randomize()
	var random_number = rng.randi_range(0, weapons_array.size() - 1)
	weapon_name = weapons_array[random_number]
	damage_modifier = random_number + 1
	fire_rate = (random_number + 1)/2.0
	$Sprite.texture = load("res://Assets/Request pack (100 assets)/PNG/" + weapon_name + ".png")
	$TextureRect.texture = load("res://Assets/Request pack (100 assets)/PNG/" + weapon_name + ".png")
	instantiated = true

func init_weapon(wid, wname, damage, rof):
	weaponid = wid
	weapon_name = wname
	damage_modifier = damage
	fire_rate = rof
	$Sprite.texture = load("res://Assets/Request pack (100 assets)/PNG/" + wname + ".png")
	$TextureRect.texture = load("res://Assets/Request pack (100 assets)/PNG/" + wname + ".png")

func fire(origin, direction):
	if $Cooldown.is_stopped():
		var projectile = projectile_scene.instance()
		projectile_stats(projectile)
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
	if pickable:
		pickable = false
#		self.visible = true
		PlayerInventory.give_index(self)
		
		set_collision_layer_bit(3, false)
		set_collision_mask_bit(0, false)
		$AnimationPlayer.play("Bounce")
		
		var data_weapon = { "name" : weapon_name, 
							"damage" : damage_modifier, 
							"rof" : fire_rate, 
							"owner" : owner_username, 
							"location" : "inventory", 
							"index" : index }
		_make_post_request(url, "addweapon", data_weapon, true)

func _spawn():
	get_node("TextureRect").visible = false
	get_node("Sprite").visible = true
	get_node("Sprite").scale = Vector2(2,2)
#	set_collision_layer_bit(0, true)
#	set_collision_mask_bit(0, true)

func _on_AnimationPlayer_animation_finished(_anim_name):
	self.visible = false

func set_weapon(w):
	$TextureRect.texture = load("res://Assets/Request pack (100 assets)/PNG/" +  w.weapon_name + ".png")
	$Sprite.texture = load("res://Assets/Request pack (100 assets)/PNG/" +  w.weapon_name + ".png")
	get_node("TextureRect").visible = true
	get_node("Sprite").visible = false

func _make_post_request(url, method, data_to_send, use_ssl):
	var query = JSON.print(data_to_send)
	$HTTPRequest.request(url + method, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	self.weaponid = json.result.id
	self.visible = true
	get_tree().root.get_node("Master/CurrentScene/Level1/Enemies").call_deferred("remove_child", self)
	PlayerInventory.add_weapon(self, self.index)
#	if(!to_inventory):
#		var json = JSON.parse(body.get_string_from_utf8())
#		id = json.result.id
#		add_to_inventory(index)
#		to_inventory = true
#	else:
#		self.visible = true
#		get_tree().root.get_node("Master/CurrentScene/Level1/Enemies").call_deferred("remove_child", self)
#		PlayerInventory.add_weapon(self)
	
