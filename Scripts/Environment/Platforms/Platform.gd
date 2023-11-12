extends Node2D
class_name Platform
@export
var direction : Vector2 
@export
var countdown := 60
@export
var step_limit := 2

@onready var player = get_node("/root/DungeonRoom_New/Player")
@onready var tile_map := $TileMap
var tile_size := Autoload.CELLSIZE
var step_counter : int
var timer : int
var cells

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("platform_boarded", check_if_player)
	timer = countdown
	step_counter = 0
	cells = tile_map.get_used_cells(0)
	print(cells)
	for cell in cells:
		Autoload.filled_cells[Vector2(cell)] = Autoload.CELLFILLERS.platform
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
	var old_pos = position
	
	position.x = position.x + direction.x * tile_size
	position.y = position.y + direction.y * tile_size
	update_cells()

func update_cells():
	var new_cells = cells.duplicate()
	for i in range(cells.size()):
		Autoload.filled_cells[Vector2(cells[i])] = null
		new_cells[i] = cells[i]+Vector2i(direction)
	cells = new_cells
	for tile in cells:
		Autoload.filled_cells[Vector2(tile)] = Autoload.CELLFILLERS.platform


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

func check_if_player(pos):
	#print("check for: ", str(pos), " on: ", str(Vector2(movement.current_pos_coords)))
	for cell in cells:
		if(Vector2(cell) == pos):
			player.sync_with_platform(timer, direction)
