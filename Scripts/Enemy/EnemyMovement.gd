extends Node2D

@onready var tile_map = get_node("/root/DungeonRoom_New/TileMap")
@onready var enemy = get_parent()
var countdown := 0.5
var timer
var a_star

var current_pos_id
var current_pos_coords
var path
var path_index = 0
var destination_id
var track_target

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = countdown
	prepare_Tilemap_for_astar()
	spawn_on_tilemap()
	random_destination()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	timer -= delta
#	if(timer <= 0):
#		move()
#		timer = countdown
#	pass

func prepare_Tilemap_for_astar():
	a_star = AStar2D.new()
	var cells = tile_map.get_used_cells(0)
	Autoload.prepare_cells(cells)
	for i in range(0, cells.size()):
		a_star.add_point(i, cells[i])
	for i in range(a_star.get_point_count()):
		var main_cell = a_star.get_point_position(i)
		var neighbor_cells = tile_map.get_surrounding_cells(main_cell)
		for cell in neighbor_cells:
			for point in range(a_star.get_point_count()):
				if (cell == Vector2i(a_star.get_point_position(point))):
					a_star.connect_points(i, point)
					break;

#places the enemy on a random position on the tilemap
func spawn_on_tilemap():
	var point_id = randi() % a_star.get_point_count()
	var start_pos = a_star.get_point_position(point_id)
	position = to_global(tile_map.map_to_local(start_pos))
	print(point_id, start_pos, position)
	current_pos_id = point_id
	current_pos_coords = start_pos



func move():
	if path_index >= path.size():
		current_pos_id = destination_id
		path_index = 0
		random_destination()
	if(Autoload.filled_cells[path[path_index]] == Autoload.CELLFILLERS.enemy):
		return
	var next_point = Vector2i(path[path_index])
	
	current_pos_coords = next_point
	position = tile_map.map_to_local(next_point)
	update_cells(path[path_index],path[path_index - 1])
	path_index += 1

func track():
	if(Autoload.filled_cells[track_target] == Autoload.CELLFILLERS.free):
		var prev = tile_map.local_to_map(position)
		position = tile_map.map_to_local(track_target)
		update_cells(tile_map.local_to_map(position), prev)
		keep_track()
	if(Autoload.filled_cells[track_target] == Autoload.CELLFILLERS.enemy):
		enemy.set_attack()

func keep_track():
	check_surroundings(1)

func update_cells(new_cell, freed_cell):
	Autoload.update_cells(new_cell, Autoload.CELLFILLERS.enemy)
	Autoload.update_cells(freed_cell, Autoload.CELLFILLERS.free)

func random_destination():
	destination_id = randi() % a_star.get_point_count()
	path = a_star.get_point_path(current_pos_id, destination_id)
	if(path.is_empty()):
		random_destination()
	

func check_surroundings(range):
	var found = false
	for cell in tile_map.get_surrounding_cells(current_pos_coords):
		for key in Autoload.filled_cells:
			if(Autoload.filled_cells[key] == Autoload.CELLFILLERS.free
			|| Autoload.filled_cells[key] == -1):
				continue
			if(cell == Vector2i(key)):
				enemy.detected(Autoload.filled_cells[key])
				track_target = Vector2(cell)
				found = true
				break
		break
	if !found:
		enemy.set_idle()

