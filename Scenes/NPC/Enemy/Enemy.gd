extends Node2D

enum STATE {idle, tracking, attack}
var current_state

@onready var player = get_node("/root/DungeonRoom_New/Player")

@onready var tile_map = get_node("/root/DungeonRoom_New/TileMap")
@onready var movement = $Movement
@onready var debug_label = $Label

@export var aggro_range := 3
@export var attack_range := 1
@export var damage := 5
#To be replaced with signals for when player turn happened
var timer
@export
var countdown := 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	player.player_turn.connect(turn)
	timer = countdown
	current_state = STATE.idle
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	timer -= delta
#	if(timer <= 0):
#		turn()
#		timer = countdown
	pass

func turn():
	debug_label.text = str(current_state)
	if(current_state == STATE.attack):
		print("ATTACK")
		current_state = STATE.tracking
	else: if(current_state == STATE.idle):
		movement.move()
		movement.check_surroundings(aggro_range)
	else: if(current_state == STATE.tracking):
		movement.track()

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
			current_state = STATE.tracking
			print("player seen")
			

func detect_player():
	print("player seen!")
	current_state = STATE.tracking

func set_attack():
	print("set to attack")
	current_state = STATE.attack
	
func attack():
	player.take_damage(damage)
	print("attack()")

func set_idle():
	current_state = STATE.idle
