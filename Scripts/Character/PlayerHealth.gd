extends Node2D

@onready
var max_health = PlayerStats.max_health
var current_health

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health
	pass # Replace with function body.

func take_damage(amount : int):
	current_health -= amount
	PlayerStats.update_health(current_health)
	if(current_health <= 0):
		die()

func die():
	print("lol")
	pass
