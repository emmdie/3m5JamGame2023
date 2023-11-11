extends TextureRect

func play_hit_effect():
	$hit_effect.start()
	$frog/eyes_happy.visible = false
	$frog/eyes_dead.visible = true
	



func _on_hit_effect_timeout():
	$frog/eyes_happy.visible = true
	$frog/eyes_dead.visible = false
