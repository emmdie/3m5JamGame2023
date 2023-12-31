extends Node2D

signal died(EXP)

enum STATE {idle, tracking, attack}
var current_state

@onready var player = get_node("/root/DungeonRoom_New/Player")

@onready var tile_map = get_node("/root/DungeonRoom_New/TileMap")
@onready var movement = $Movement

@export var aggro_range := 3
@export var attack_range := 1
@export var damage := 5
@export var spawn_coords : Vector2i
var health := randi_range(5, 25) 
var granted_exp = 1
#To be replaced with signals for when player turn happened
var timer
@export
var countdown := 0.5

@onready var gothit = $Movement/Sprite2D

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
	$DamageLabel.position += Vector2(0, -50 * delta)

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
	else:
		var tween = get_tree().create_tween()
		tween.finished.connect(reset_color_modulation)
		tween.tween_property(gothit, "modulate", Color(1, 0, 0), 0.2)
		
@onready var previousColor = gothit.modulate

func reset_color_modulation():
	gothit.modulate = previousColor

func die():
	Autoload.filled_cells[Vector2(movement.current_pos_coords)] = Autoload.CELLFILLERS.free
	died.emit(granted_exp)
	queue_free()

func check_if_hit(pos, amount):
	print("check for: ", str(pos), " on: ", str(Vector2(movement.current_pos_coords)))
	if(Vector2(movement.current_pos_coords) == pos):
		print("hit!")
		take_damage(amount)

func set_idle():
	current_state = STATE.idle

func show_damage_number(number):
	$DamageLabel.text = str(number)
	$DamageLabel.visible = true
	$DamageLabel.position = Vector2(-34,-62)
	$DamageTimer.start()


func _on_damage_timer_timeout():
	$DamageLabel.visible = false
