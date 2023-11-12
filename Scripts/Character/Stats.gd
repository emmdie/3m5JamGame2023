extends Node2D

@onready var current_EXP = 0
@onready var needed_EXP = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func raise_EXP(EXP):
	current_EXP += EXP
	if current_EXP >= needed_EXP:
		current_EXP = current_EXP - needed_EXP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
