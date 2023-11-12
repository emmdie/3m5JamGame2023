extends Node

@onready var current_level = 0

func choose_level(level):
	current_level = level

func next_level():
	current_level+=1

func get_current_level():
	return current_level
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
