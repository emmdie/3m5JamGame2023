extends Node

const default_max_health = 100
@onready var max_health = default_max_health
var current_health

func _ready():
	reset_player_progress()
	
func update_health(new_health : int):
	current_health = new_health

func reset_player_progress():
	current_health = default_max_health
	max_health = default_max_health
