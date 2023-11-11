extends Node2D

@onready var tile_map = get_node("/root/DungeonRoom/TileMap")

var countdown := 0.5
var timer
var a_star

var current_pos_id
var path
var path_index = 0
var destination_id

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = countdown
	prepare_Tilemap_for_astar()
	spawn_on_tilemap()
	random_destination()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if(timer <= 0):
		move()
		timer = countdown
	pass

func prepare_Tilemap_for_astar():
	a_star = AStar2D.new()
	var cells = tile_map.get_used_cells(0)
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
	current_pos_id = point_id



func move():
	if path_index >= path.size():
		current_pos_id = destination_id
		path_index = 0
		random_destination()
	var next_point = Vector2i(path[path_index])
	
	path_index += 1
	position = tile_map.map_to_local(next_point)
	print(next_point)
	print(position)


func random_destination():
	destination_id = randi() % a_star.get_point_count()
	path = a_star.get_point_path(current_pos_id, destination_id)
	if(path.is_empty()):
		random_destination()
	print(path)
