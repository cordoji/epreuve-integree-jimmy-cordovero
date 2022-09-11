extends Area2D

var projectile_scene = preload("res://Scenes/Projectile.tscn")

var weapon_name
var weapons_array = ["raygun", "raygunBig", "raygunPurple", "raygunPurpleBig"]

var damage_modifier
var fire_rate

var rng = RandomNumberGenerator.new()

func _ready():
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
		print(projectile.damage)
		print($Cooldown.wait_time)
		print(fire_rate)
		get_tree().root.add_child(projectile)
		projectile_in_scene(projectile, origin, direction)
		projectile.get_node("Sprite").texture = load("res://Assets/Request pack (100 assets)/PNG/laserRedHorizontal.png")
		$Cooldown.start()

func projectile_stats(projectile):
		projectile.damage *= damage_modifier
		$Cooldown.wait_time = fire_rate
#	projectile.SPEED = projectile.SPEED * 2
#	if weapon_name == "raygunBig":
#		projectile.damage *= 2
#		$Cooldown.wait_time = 1
#	if weapon_name == "raygunPurple":
#		projectile.damage /= 2
#		$Cooldown.wait_time = 0.25
#	if weapon_name == "raygunPurpleBig":
#		projectile.damage *= 4
#		$Cooldown.wait_time = 2

func projectile_in_scene(projectile, origin, direction):
	projectile.global_position = origin
	var projectile_rotation = origin.direction_to(direction).angle()
	projectile.rotation = projectile_rotation

func _on_Weapon_body_entered(_body):
	
	PlayerInventory.add_weapon(self)
	$AnimationPlayer.play("Bounce")

func _spawn():
	get_node("TextureRect").visible = false
	get_node("Sprite").visible = true
	get_node("Sprite").scale = Vector2(2,2)
#	set_collision_layer_bit(0, true)
#	set_collision_mask_bit(0, true)

func _on_AnimationPlayer_animation_finished(_anim_name):
	get_tree().root.get_node("Master/CurrentScene/Level1/Enemies").call_deferred("remove_child", self)

func set_weapon(w):
	$TextureRect.texture = load("res://Assets/Request pack (100 assets)/PNG/" +  w.weapon_name + ".png")
	get_node("TextureRect").visible = true
	get_node("Sprite").visible = false
