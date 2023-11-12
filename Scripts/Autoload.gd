extends Node
const level = "res://Scenes/Dungeon/DungeonRoom_New.tscn"
const title_screen = "res://Scenes/Ui/TitleScreen.tscn"
const CELLSIZE := 64

enum CELLFILLERS {item, player, free, platform, enemy}
var filled_cells := {Vector2.ZERO:-1}

func update_cells(pos: Vector2, value):
	filled_cells[pos] = value

func is_cell_free(key: Vector2) -> bool:
	if(filled_cells[key] >= CELLFILLERS.free):
		return true
	else:
		return false

func print_player_pos():
	print(get_player_pos)

func get_player_pos():
	for key in filled_cells:
		if(filled_cells[key] == CELLFILLERS.player):
			return key

func prepare_cells(cells):
	for cell in cells:
		filled_cells[Vector2(cell)] = CELLFILLERS.free

func print_cells():
	var string = ""
	for cell in filled_cells:
		if(filled_cells[cell] != 99):
			string += str("Cell: "+str(cell))
			string += str("Value: "+str(filled_cells[cell])+"\n")
		
	print(string)
