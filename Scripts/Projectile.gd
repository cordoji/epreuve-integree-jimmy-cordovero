extends Area2D

var SPEED = 1000

#func _ready():
#	$Sprite.texture = load("res://Assets/Request pack (100 assets)/PNG/dirtCaveRockSmall.png")

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta

func destroy():
	queue_free()
