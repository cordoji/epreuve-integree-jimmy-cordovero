extends KinematicBody2D

var SPEED = 1000

var velocity = Vector2(0,0)
var GRAVITY = 0
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

func bounce():
	destroy()
