extends Control

@onready var health_bar = $HBoxContainer/hp_bar
@onready var portrait = $HBoxContainer/Portrait

func _ready():
	update_health()
	PlayerStats.connect("health_change", update_health)
	
func update_health():
	var previous_health = health_bar.value
	health_bar.max_value = PlayerStats.max_health
	health_bar.value = PlayerStats.current_health
	if health_bar.value < previous_health:
		play_hit_effect()

func play_hit_effect():
	portrait.play_hit_effect()
