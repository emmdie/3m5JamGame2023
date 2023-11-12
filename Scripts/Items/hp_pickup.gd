extends Node2D

@onready var player = get_node("/root/DungeonRoom_New/Player")
@onready var tile_map = get_node("/root/DungeonRoom_New/TileMap")
var hp = 3
@export var spawn_coords : Vector2i

func _ready():
	player.connect("item_pickup", check_pickup)
	var cells = tile_map.get_used_cells(0)
	var spawn_cell
	if(spawn_coords == Vector2i.ZERO):
		spawn_coords = cells[randi() % cells.size()]
		spawn(spawn_coords)
	else: for cell in cells:
		if cell == spawn_coords:
			spawn(spawn_coords)
	print(spawn_coords)

func spawn(cell):
	Autoload.filled_cells[Vector2(cell)] = Autoload.CELLFILLERS.item
	position = to_global(tile_map.map_to_local(cell))

func pickup():
	PlayerStats.update_health(PlayerStats.current_health + hp)
	$PickupSound.play()
	hp = 0
	visible = false
	Autoload.filled_cells[Vector2(spawn_coords)] = Autoload.CELLFILLERS.free
	
func _on_pickup_sound_finished():
	queue_free()

func check_pickup(cell):
	if(cell == Vector2(spawn_coords)):
		pickup()

func _on_area_2d_area_entered(area):
	if area.has_method("stretch_tongue"):
		#pickup()
		pass
