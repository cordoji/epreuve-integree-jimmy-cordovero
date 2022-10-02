extends Area2D

#signal coin_collected
var url = "https://contralands.azurewebsites.net/"
var headers = ["Content-Type: application/json"]

var pickable = true

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

# warning-ignore:unused_argument
func _on_Coin_body_entered(body):
	if(pickable):
		pickable = false
		set_collision_mask_bit(0, false)
		set_collision_layer_bit(0, true)
		$AnimationPlayer.play("Bounce")
		get_tree().root.get_node("Master").add_coin()
		var data_to_send = { "id" : get_tree().root.get_node("Master").userid, "coins" : get_tree().root.get_node("Master").coins}
		_make_post_request(url, "addcoin", data_to_send, true)
	#	emit_signal("coin_collected")
		$SoundCoinCollect.play()
	

func _spawn():
	$Timer.start()


# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	self.visible = false


func _on_Timer_timeout():
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)

func _make_post_request(url, method, data_to_send, use_ssl):
	var query = JSON.print(data_to_send)
	$HTTPRequest.request(url + method, headers, use_ssl, HTTPClient.METHOD_POST, query)

func _on_request_completed(result, response_code, headers, body):
#	self.visible = true
	queue_free()
