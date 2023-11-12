extends Control

@onready var health_label = $CenterContainer/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/HealthLabel
@onready var damage_label = $CenterContainer/TextureRect/MarginContainer/VBoxContainer/HBoxContainer2/DamageLabel

func leve_up():
	visible = true
	health_label.text = "MAX HP: "+ str(PlayerStats.max_health)
	damage_label.text = "Player dmg"
	$LevelUpSound.play()
	
func close():
	visible = false
	
func _on_damage_button_pressed():
	close()

func _on_health_button_pressed():
	PlayerStats.max_health += 30
	PlayerStats.current_health += 30
	close()
