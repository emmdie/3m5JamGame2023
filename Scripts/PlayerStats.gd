extends Node

const default_max_health = 100
@onready var max_health = default_max_health
@onready var current_exp = 0
@onready var needed_exp = 5
@onready var level = 0
var current_health

signal health_change
signal levelup

func _ready():
	reset_player_progress()

func update_health(new_health : int):
	current_health = new_health
	emit_signal("health_change")

func level_up():
	level += 1
	emit_signal("levelup")

func reset_player_progress():
	current_health = default_max_health
	max_health = default_max_health
	current_exp = 0
