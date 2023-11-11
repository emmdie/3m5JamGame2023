extends Node2D
class_name Platform

@export
var tile_size : Vector2 
@export
var direction : Vector2 
@export
var countdown : int
@export
var step_limit : int

var step_counter : int
var timer : int


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = countdown
	step_counter = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if timer == 0:
		_move()
		step_counter += 1
		if(step_counter == step_limit):
			_change_direction()
			step_counter = 0
		timer = countdown
	pass

func _move():
	position.x = position.x + direction.x * tile_size.x
	position.y = position.y + direction.y * tile_size.y
	

func _change_direction():
	pass

func _change_direction_counter_clockwise():
	match direction:
		Vector2.DOWN:
			direction = Vector2.RIGHT
		Vector2.RIGHT:
			direction = Vector2.UP
		Vector2.UP:
			direction = Vector2.LEFT
		Vector2.LEFT:
			direction = Vector2.DOWN
