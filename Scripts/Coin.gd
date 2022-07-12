extends Area2D

signal coin_collected

# warning-ignore:unused_argument
func _on_Coin_body_entered(body):
	$AnimationPlayer.play("Bounce")
	emit_signal("coin_collected")
	#set_connection_mask_bit(0, false)
	$SoundCoinCollect.play()

func _spawn():
	$Timer.start()


# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _on_Timer_timeout():
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)
