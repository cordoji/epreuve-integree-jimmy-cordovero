extends KinematicBody2D

var velocity = Vector2()
export var direction = -1 # 1 = right // -1 = left
export var detects_cliffs = true
var speed = 50

func _ready():
	if direction == -1:
		$AnimatedSprite.flip_h = true
	$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	#if detects_cliffs:
		#set_modulate(Color(1.2, 0.5, 1))
	
func _physics_process(delta):
	
	if is_on_wall() or not $FloorChecker.is_colliding() and is_on_floor() and detects_cliffs:
		direction *= -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$FloorChecker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += 20
	
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
	



func _on_TopChecker_body_entered(body):
	$AnimatedSprite.play("Killed")
	speed = 0
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(1, false)
	$TopChecker.set_collision_layer_bit(4, false)
	$TopChecker.set_collision_mask_bit(0, false)
	$Sides.set_collision_layer_bit(4, false)
	$Sides.set_collision_mask_bit(0, false)
	$Timer.start()
	body.bounce()
	$SoundKill.play(0.1)


func _on_Sides_body_entered(body):
	#print("ouch")
	if body is RigidBody2D:
		print("ouch")
		$AnimatedSprite.play("Killed")
		speed = 0
		set_collision_layer_bit(4, false)
		set_collision_mask_bit(0, false)
		set_collision_mask_bit(1, false)
		$Timer.start()
		$SoundKill.play(0.1)
	elif body.name == "Player":
		body.ouch(position.x)


func _on_Timer_timeout():
	queue_free()
