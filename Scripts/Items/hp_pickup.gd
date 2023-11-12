extends Control

const hp = 3

func pickup():
	PlayerStats.current_health += hp
	$PickupSound.play()
	
func _on_pickup_sound_finished():
	queue_free()
