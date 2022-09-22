extends KinematicBody2D

var SPEED = 2000
var damage = 30

var velocity = Vector2(0,0)
var GRAVITY = 0
var tempV = velocity.y

#func _ready():
#	$Sprite.texture = load("res://Assets/Request pack (100 assets)/PNG/dirtCaveRockSmall.png")

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
	
	velocity.y = velocity.y + GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, 0.1)

func destroy():
	queue_free()

func hit():
	$Label.visible = true
	$Label.text = str(damage)
	set_collision_layer_bit(5, false)
	SPEED = 0
	GRAVITY = 0
	velocity.y = 0
	$Sprite.visible = false
	if $Sprite.texture == load("res://Assets/Request pack (100 assets)/PNG/laserRedHorizontal.png"):
		$OnHit.play("Burst")
	else:
		$HitEffect.texture = null
		$OnHit.play("Burst")
		
#	destroy()


func _on_OnHit_animation_finished(_anim_name):
	destroy()


func _on_Timer_timeout():
	destroy()

