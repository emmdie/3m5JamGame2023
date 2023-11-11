extends Node2D

enum STATE {idle, tracking, attack}
var current_state

@onready var tile_map = get_node("/root/DungeonRoom/TileMap")
@onready var movement = $Movement
@export var aggro_range := 1
#To be replaced with signals for when player turn happened
var timer
@export
var countdown := 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = countdown
	current_state = STATE.idle
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if(timer <= 0):
		movement.check_surroundings(aggro_range)
		if(current_state == STATE.idle):
			movement.move()
		timer = countdown
	pass
