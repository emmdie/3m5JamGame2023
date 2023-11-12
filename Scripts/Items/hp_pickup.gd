extends Control

var hp = 3

func pickup():
	PlayerStats.current_health += hp
	$PickupSound.play()
	hp = 0
	visible = false
	
func _on_pickup_sound_finished():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.has_method("stretch_tongue"):
		pickup()
