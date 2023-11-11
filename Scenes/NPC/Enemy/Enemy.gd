extends Node2D

enum STATE {idle, tracking, attack}
var current_state

@onready var tile_map = get_node("/root/DungeonRoom_New/TileMap")
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
		if(current_state == STATE.attack):
			print("ATTACK")
			current_state = STATE.tracking
		else: if(current_state == STATE.idle):
			movement.move()
		else: if(current_state == STATE.tracking):
			movement.track()
		movement.check_surroundings(aggro_range)
		timer = countdown
	pass

func detected(object):
	if current_state == STATE.attack:
		return
	match object:
		Autoload.CELLFILLERS.enemy:
			#track and attack
			current_state = STATE.tracking
			print("enemy seen")
		Autoload.CELLFILLERS.item:
			#track and pick up
			print("item")
		Autoload.CELLFILLERS.player:
			#track and attack
			print("player")
			

func set_attack():
	print("set to attack")
	current_state = STATE.attack

func set_idle():
	current_state = STATE.idle
