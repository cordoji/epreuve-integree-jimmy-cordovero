extends KinematicBody2D

var velocity = Vector2(0,0)
var coins = 0
const SPEED = 300
const GRAVITY = 30
const JUMPFORCE = -900

func _ready():
	PlayerInventory.connect("active_weapon_updated", self, "refresh_displayed_weapon")

func _physics_process(delta):
	
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$Sprites/AnimationPlayer.play("Walk_right")
		$Sprites/Body.flip_h = false
		$Sprites/Weapon.flip_h = false
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

func _on_FallZone_body_entered(body):
	get_tree().change_scene("res://Scenes/GameOver.tscn")

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
	if PlayerInventory.equips.has(PlayerInventory.active_weapon_slot) != false:
		$Sprites/Weapon.texture = load("res://Assets/Request pack (100 assets)/PNG/" + PlayerInventory.equips[PlayerInventory.active_weapon_slot][0] + ".png")
	else:
		$Sprites/Weapon.texture = null
