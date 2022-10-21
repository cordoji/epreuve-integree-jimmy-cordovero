extends KinematicBody2D

var projectile_scene = preload("res://Scenes/Projectile.tscn")

var id

var startPosition = Vector2(0,0)
var velocity = Vector2(0,0)
var coins = 0
const SPEED = 300
const GRAVITY = 30
const JUMPFORCE = -1200

func _ready():
	PlayerInventory.connect("active_weapon_updated", self, "refresh_displayed_weapon")
	startPosition = self.position
	id = "player"
	refresh_displayed_weapon()
	get_tree().root.get_node("Master/Timer").start()

func _physics_process(_delta):
	
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$Sprites/AnimationPlayer.play("Walk_right")
		$Sprites/Body.flip_h = false
#		$Sprites/Weapon.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$Sprites/AnimationPlayer.play("Walk_left")
		$Sprite.flip_h = true
	else:
		$Sprites/AnimationPlayer.play("Idle")
		
	if not is_on_floor():
		if Input.is_action_pressed("left"):
			$Sprites/AnimationPlayer.play("Air_left")
		else:
			$Sprites/AnimationPlayer.play("Air_right")
	
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE
		$SoundJump.play()
		
	if Input.is_action_pressed("shoot") and get_global_mouse_position().x > global_position.x:
		$Sprites/AnimationPlayer.play("Shoot_right")
	
	if Input.is_action_pressed("shoot") and get_global_mouse_position().x < global_position.x:
		$Sprites/AnimationPlayer.play("Shoot_left")
		
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x, 0, 0.1)
	
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot():
	var origin = Vector2(self.global_position.x + 15, self.global_position.y + 15)
	if PlayerInventory.equips.has(PlayerInventory.active_weapon_slot):
		PlayerInventory.current_weapon.fire(Vector2(origin.x + 20, origin.y +10), get_global_mouse_position())
	else:
		throw_rock(origin, get_global_mouse_position())

func throw_rock(origin, direction):
	if $RockTimer.is_stopped():
		var projectile = projectile_scene.instance()
		rock_stats(projectile)
		rock_in_scene(projectile, origin, direction)
		$RockTimer.start()

func rock_stats(projectile):
	projectile.SPEED = projectile.SPEED / 4
	projectile.GRAVITY = 15
	projectile.damage = 30

func rock_in_scene(projectile, origin, direction):
	projectile.get_node("Sound").stream = null
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = origin
	var projectile_rotation = self.global_position.direction_to(direction).angle()
	projectile.rotation = projectile_rotation
	projectile.get_node("Sprite").texture = load("res://Assets/Request pack (100 assets)/PNG/dirtCaveRockSmall.png")

func _on_FallZone_body_entered(_body):
#	get_tree().change_scene("res://Scenes/GameOver.tscn")
#	var currentScene = get_tree().root.get_node("Master").current_scene
#	get_tree().root.get_node("Master/CurrentScene").call_deferred("remove_child", currentScene)
#	get_tree().root.get_node("Master/CurrentScene").call_deferred("add_child", currentScene)
	self.position = startPosition
	

func bounce():
	velocity.y = JUMPFORCE * 0.5

func ouch(var enemyposx):
	set_modulate(Color(1, 0.3, 0.3, 0.3))
	velocity.y = JUMPFORCE * 0.4
	
	if position.x < enemyposx:
		velocity.x = JUMPFORCE * 0.5
	elif position.x > enemyposx:
		velocity.x = JUMPFORCE * -0.5
		
	Input.action_release("left")
	Input.action_release("right")
	
	$Timer.start()

func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/GameOver.tscn")

func refresh_displayed_weapon():
	if PlayerInventory.equips.has(int(PlayerInventory.active_weapon_slot)):
		$Sprites/WeaponSprite.texture = load("res://Assets/Request pack (100 assets)/PNG/" + PlayerInventory.current_weapon.weapon_name + ".png")
	else:
		$Sprites/WeaponSprite.texture = null
