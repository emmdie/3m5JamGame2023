extends Control

@onready var enemies = $Enemies
@onready var player = $Player
@onready var tile_map = get_node("/root/DungeonRoom_New/TileMap")

# Called when the node enters the scene tree for the first time.

func _ready():
	
	var free_tiles = []
	
	for i in tile_map.get_used_cells(0):
		if Autoload.filled_cells.get(Vector2(i)) == Autoload.CELLFILLERS.free:
			free_tiles.append(i)
	
	var goal_coordinates = free_tiles[randi() % free_tiles.size()]

	
	#set goal in Autoload
	Autoload.update_cells(goal_coordinates, Autoload.CELLFILLERS.goal)
	#set goal in Tile Map
	var goal = get_node("/root/DungeonRoom_New/Goal")
	goal.position = goal.to_global(tile_map.map_to_local(goal_coordinates))
	
	for enemy in enemies.get_children():
		enemy.died.connect(_on_enemy_killed)

func _on_enemy_killed(EXP):
	player.give_exp(EXP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$Bg_music.playing:
		$Bg_music.play()
