extends Node2D

@onready var tile_map = get_node("/root/DungeonRoom_New/TileMap")
@onready var enemy = get_parent()

const MAX_RANGE_X = 6
const MAX_RANGE_Y = 6
@onready var STARTING_POSITION

var countdown := 0.5
var timer
var a_star
var a_star_dict := {} #for ease of access to point ids

var current_pos_id
var current_pos_coords : Vector2i
var path
var path_index = 0
var destination_id
var track_target


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = countdown
	prepare_Tilemap_for_astar()
	STARTING_POSITION = spawn_on_tilemap()
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
		a_star_dict[i] = cells[i]
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
	var point_id
	if(enemy.spawn_coords == Vector2i.ZERO):
		point_id = randi() % a_star.get_point_count()
	else: point_id = a_star_dict.find_key(enemy.spawn_coords)
	var start_pos = a_star.get_point_position(point_id)
	position = to_global(tile_map.map_to_local(start_pos))
	print(point_id, start_pos, position)
	current_pos_id = point_id
	current_pos_coords = start_pos
	Autoload.filled_cells[Vector2(current_pos_coords)] = Autoload.CELLFILLERS.enemy
	
	return point_id



func move(random := true):
	if path_index >= path.size() || Autoload.filled_cells[path[path_index]] != Autoload.CELLFILLERS.free:
		current_pos_id = destination_id
		path_index = 1
		if random: random_destination()
	if(Autoload.filled_cells[path[path_index]] == Autoload.CELLFILLERS.player):
		enemy.attack()
		path.clear()
		return
	var next_point = Vector2i(path[path_index])
	
	current_pos_coords = next_point
	position = tile_map.map_to_local(next_point)
	update_cells(path[path_index],path[path_index - 1])
	path_index += 1

func track():
	path.clear()
	#Calculate DISTANCE to target
	path = a_star.get_point_path(a_star_dict.find_key(current_pos_coords),a_star_dict.find_key(track_target))
	var distance = path.size()-1  #-1 von der path size, da in dem array die current position des enemies mit drin ist, und die zähelen wir nicht mit
	path_index = 1
	if(distance <= enemy.attack_range): 
		enemy.attack()
	else: 
		move(false)
		
	keep_track()
#	if(Autoload.filled_cells[Vector2(track_target)] == Autoload.CELLFILLERS.free):
#		var prev = tile_map.local_to_map(position)
#		position = tile_map.map_to_local(track_target)
#		update_cells(tile_map.local_to_map(position), prev)
#		keep_track()
#	if(Autoload.filled_cells[Vector2(track_target)] == Autoload.CELLFILLERS.player):
#		enemy.set_attack()

func keep_track():
	check_surroundings(enemy.aggro_range)

func update_cells(new_cell, freed_cell):
	Autoload.update_cells(new_cell, Autoload.CELLFILLERS.enemy)
	Autoload.update_cells(freed_cell, Autoload.CELLFILLERS.free)


func get_xy_distance(from_id, to_id):
	var dx = abs(a_star_dict.get(to_id)[0] - a_star_dict.get(from_id)[0])
	var dy = abs(a_star_dict.get(to_id)[1] - a_star_dict.get(from_id)[1])
	return [dx, dy]


func random_destination():
	while(true):
		destination_id = randi() % a_star.get_point_count()
		var distance = get_xy_distance(STARTING_POSITION, destination_id)
		path = a_star.get_point_path(current_pos_id, destination_id)

		if distance[0] < MAX_RANGE_X and path.size() > 1 and distance[1] < MAX_RANGE_Y:
			break
	

func check_surroundings(range) -> bool:
	var found = false
	var player_pos = Autoload.get_player_pos()
	for tile in a_star_dict.values():
		if(player_pos == Vector2(tile)):
			
			var neighbor_cells = tile_map.get_surrounding_cells(current_pos_coords)
			get_cells_in_range(range)
			for cell in get_cells_in_range(range):
				if(Vector2(cell) == Autoload.get_player_pos()):
					enemy.detect_player()
					track_target = cell
					found = true
					return found
					break
		
	return found
#			if(Autoload.filled_cells[key] >= Autoload.CELLFILLERS.free):
#				continue
#			if(cell == Vector2i(key)):
#				enemy.detected(Autoload.filled_cells[key])
#				track_target = Vector2(cell)
#				found = true
#				break
#
#	if !found:
#		enemy.set_idle()

func get_cells_in_range(range):
	var cell_arr = []
	for x in range(current_pos_coords.x - range, current_pos_coords.x + range+1):
		for y in range(current_pos_coords.y - range, current_pos_coords.y + range+1):
			cell_arr.append(Vector2i(x,y))
	return cell_arr
