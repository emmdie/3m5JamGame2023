extends Control

@onready var health_bar = $HBoxContainer/hp_bar
@onready var portrait = $HBoxContainer/Portrait
@onready var level_up_screen = $LevelUpScreen

func _ready():
	update_health()
	PlayerStats.connect("health_change", update_health)
	PlayerStats.connect("levelup", level_up)
	
func update_health():
	var previous_health = health_bar.value
	health_bar.max_value = PlayerStats.max_health
	health_bar.value = PlayerStats.current_health
	if health_bar.value < previous_health:
		play_hit_effect()
	if PlayerStats.current_health <= 0:
		$GameOverScreen.show_game_over()

func level_up():
	level_up_screen.level_up()

func play_hit_effect():
	portrait.play_hit_effect()
