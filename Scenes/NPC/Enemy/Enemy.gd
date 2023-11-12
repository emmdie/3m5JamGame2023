extends Node2D

enum STATE {idle, tracking, attack}
var current_state

@onready var player = get_node("/root/DungeonRoom_New/Player")

@onready var tile_map = get_node("/root/DungeonRoom_New/TileMap")
@onready var movement = $Movement

@export var aggro_range := 3
@export var attack_range := 1
@export var damage := 5
var health := randi_range(5, 25) 
#To be replaced with signals for when player turn happened
var timer
@export
var countdown := 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	player.player_turn.connect(turn)
	player.attack_hit.connect(check_if_hit)
	timer = countdown
	current_state = STATE.idle
	print(health)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	timer -= delta
#	if(timer <= 0):
#		turn()
#		timer = countdown
	pass

func turn():
	if(current_state == STATE.attack):
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
			pass
		Autoload.CELLFILLERS.item:
			#track and pick up
			print("item")
		Autoload.CELLFILLERS.player:
			#track and attack
			current_state = STATE.tracking
			

func detect_player():
	current_state = STATE.tracking

func set_attack():
	current_state = STATE.attack
	
func attack():
	player.take_damage(damage)

func take_damage(amount: int):
	health -= amount
	#visual feedback
	if(health <= 0):
		die()

func die():
	Autoload.filled_cells[Vector2(movement.current_pos_coords)] = Autoload.CELLFILLERS.free
	queue_free()

func check_if_hit(pos, amount):
	print("check for: ", str(pos), " on: ", str(Vector2(movement.current_pos_coords)))
	if(Vector2(movement.current_pos_coords) == pos):
		print("hit!")
		take_damage(amount)

func set_idle():
	current_state = STATE.idle
