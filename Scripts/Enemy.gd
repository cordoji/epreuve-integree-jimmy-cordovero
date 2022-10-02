extends KinematicBody2D

var velocity = Vector2()
export var direction = -1 # 1 = right // -1 = left
export var detects_cliffs = true
var speed = 50

var base_health = 100
onready var health = base_health

var coin_scene = preload("res://Scenes/Coin.tscn")
var weapon_scene = preload("res://Scenes/Weapon.tscn")
#var spawned


func _ready():
	$HealthBar/ProgressBar.max_value = base_health
	if direction == -1:
		$AnimatedSprite.flip_h = true
	$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	#if detects_cliffs:
		#set_modulate(Color(1.2, 0.5, 1))
	
func _physics_process(_delta):
	
	if is_on_wall() or not $FloorChecker.is_colliding() and is_on_floor() and detects_cliffs:
		direction *= -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
		
	
	
	velocity.y += 20
	
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
	

func stop_collisions():
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(1, false)
	set_collision_mask_bit(5, false)
	$HitBox.set_collision_layer_bit(4, false)
	$HitBox.set_collision_mask_bit(0, false)
	$HitBox.set_collision_mask_bit(5, false)

func _spawn_item():
	var weapon = weapon_scene.instance()
	weapon.instantiate()
	weapon.set_collision_layer_bit(0, false)
	weapon.set_collision_mask_bit(0, false)
	weapon.position = position
#	get_tree().root.get_node("Master/CurrentScene/Level1/Enemies").call_deferred("add_child", weapon)
	self.get_parent().call_deferred("add_child", weapon)
	
	weapon._spawn()

func _on_HitBox_body_entered(body):
	if body is KinematicBody2D:
		health -= body.damage
		$HealthBar/ProgressBar.value = health
		
		if $HealthBar/ProgressBar.value != $HealthBar/ProgressBar.max_value:
			$HealthBar.visible = true
		else:
			$HealthBar.visible = false
		body.hit()
		if health <= 0:
			$AnimatedSprite.play("Killed")
			speed = 0
			stop_collisions()
			_spawn_item()
			$SoundKill.play(0.1)

#func _on_Sides_body_entered(body):
#	#print("ouch")
#	if body is KinematicBody2D:
#		$AnimatedSprite.play("Killed")
#		speed = 0
#		stop_collisions()
#		_spawn_item()
#		body.hit()
#		#$Timer.start()
#		$SoundKill.play(0.1)
#	elif body.name == "Player":
#		body.ouch(position.x)
#	elif body.name == "Projectile":
#		body.destroy()

func _on_Timer_timeout():
	queue_free()
	#spawned.set_collision_layer_bit(0, true)
	#spawned.set_collision_mask_bit(0, true)

