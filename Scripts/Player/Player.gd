extends Area2D

signal player_turn
signal attack_hit
@export var bump_sound = load("res://Assets/Music/SFX/Bumping into Wall.wav")
@export var attack_sound = load("res://Assets/Music/SFX/Zunge.wav")

@onready var walkable_ray = $PlayerWalkableChecker
@onready var tongue = $PlayerTongue
@onready var audio_player = $PlayerSounds
@onready var health = $Health
var tile_size = 64
var jump_length := 2
var arrow_keys = {"RIGHT": Vector2.RIGHT,
			"LEFT": Vector2.LEFT,
			"UP": Vector2.UP,
			"DOWN": Vector2.DOWN}
var wasd = {"W": Vector2.UP,
			"A": Vector2.LEFT,
			"S": Vector2.DOWN,
			"D": Vector2.RIGHT}
var jump_keys = {"JUMPRIGHT": Vector2.RIGHT * jump_length,
			"JUMPLEFT": Vector2.LEFT * jump_length,
			"JUMPUP": Vector2.UP * jump_length,
			"JUMPDOWN": Vector2.DOWN * jump_length}

var walking_animation_speed = 6
var tongue_animation_reach = 2.5
var tongue_animation_speed =6

var moving = false
var prev_pos
var attack_damage = 5

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	#BAD MAGIC NUMBER to know where the player starts on the tilemap
	Autoload.filled_cells[Vector2(13,2)] = Autoload.CELLFILLERS.player
	prev_pos = Vector2(13,2)

#checks if the player is allowed to move
func _unhandled_input(event):
	if moving:
		return
	for dir in jump_keys.keys():
		if event.is_action_pressed(dir):
			if(dir == "JUMPLEFT" || dir == "JUMPRIGHT"):
				jump_horizontal(jump_keys[dir])
			if(dir == "JUMPUP" || dir == "JUMPDOWN"):
				jump_vertical(jump_keys[dir])
			emit_signal("player_turn")
			return
	for dir in arrow_keys.keys():
		if event.is_action_pressed(dir):
			move(arrow_keys[dir])
			return
	for dir in wasd.keys():
		if event.is_action_pressed(dir):
			attack(dir)
			return

#moves and animates the movement
func move(dir):
	walkable_ray.target_position = dir * tile_size
	walkable_ray.force_raycast_update()
	if walkable_ray.is_colliding() && Autoload.filled_cells.get(prev_pos + dir) != Autoload.CELLFILLERS.enemy:
		update_cells(dir)
		var tween = create_tween()
		tween.finished.connect(_on_moving_tween_finished)
		tween.tween_property(self, "position",position + dir *    tile_size, 1.0/walking_animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		emit_signal("player_turn")
	else :
		audio_player.stream = bump_sound
		audio_player.play()

func jump_vertical(dir):
	var destination = Autoload.filled_cells.get(prev_pos + dir)
	var pos_x_start = position.x
	var pos_x_end = position.x+dir.x-1.25 * tile_size
	if(destination != null && destination != Autoload.CELLFILLERS.enemy):
		update_cells(dir)
		var tween_y = create_tween()
		var tween = create_tween()
		tween_y.tween_property(self, "position:y", position.y+dir.y * tile_size, 1.0/walking_animation_speed).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "position:x", pos_x_end, 1.0/walking_animation_speed/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position:x", pos_x_start, 1.0/walking_animation_speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_delay(1.0/walking_animation_speed/2)


func jump_horizontal(dir):
	var destination = Autoload.filled_cells.get(prev_pos + dir)
	var pos_y_start = position.y
	var pos_y_end = position.y+dir.y-1.25 * tile_size
	if(destination != null && destination != Autoload.CELLFILLERS.enemy):
		update_cells(dir)
		var tween_x = create_tween()
		var tween = create_tween()
		tween_x.tween_property(self, "position:x", position.x+dir.x * tile_size, 1.0/walking_animation_speed).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "position:y", pos_y_end, 1.0/walking_animation_speed/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position:y", pos_y_start, 1.0/walking_animation_speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).set_delay(1.0/walking_animation_speed/2)

func update_cells(direction):
	var new_pos = prev_pos + direction
	Autoload.filled_cells[new_pos] = Autoload.CELLFILLERS.player
	Autoload.filled_cells[prev_pos] = Autoload.CELLFILLERS.free
	prev_pos = new_pos
	

#erlaubt den Spieler nach abspielen der Animation wieder zu bewegen
func _on_moving_tween_finished():
	moving = false

func attack(dir):
	audio_player.stream = attack_sound
	audio_player.play()
	if dir == "D":
		tongue.flip_v = false
		tongue.rotation = 0
		tongue.show()
		stretch_tongue()
		tongue.flip_v = true
	if dir == "W":
		tongue.rotation = -0.5 * PI
		tongue.show()
		stretch_tongue()
	if dir == "A":
		tongue.flip_h = true
		tongue.rotation = -PI
		tongue.show()
		stretch_tongue()
		tongue.flip_h = false
	if dir == "S":
		tongue.rotation = 0.5 * PI
		tongue.show()
		stretch_tongue()
	check_enemy_presence(wasd[dir])
	emit_signal("player_turn")

func stretch_tongue():
	var tween = create_tween()
	tween.finished.connect(_on_tongue_tween_finished)
	tween.tween_property(tongue,"scale",Vector2(tongue_animation_reach,1), 1.0/tongue_animation_speed).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(tongue,"scale",Vector2(1,1), 1.0/tongue_animation_speed).set_trans(Tween.TRANS_LINEAR)
	

func _on_tongue_tween_finished():
	await get_tree().create_timer(0.05).timeout
	tongue.hide()
	moving = false



func check_enemy_presence(direction):
	var attack_destination = prev_pos + direction
	print("attack destination is: ", str(attack_destination), "cell is ", str(Autoload.filled_cells.get(attack_destination)))
	if(Autoload.filled_cells.get(attack_destination) == Autoload.CELLFILLERS.enemy):
		emit_signal("attack_hit", attack_destination, attack_damage)

func take_damage(damage : int):
	health.take_damage(damage)

func levelup():
	PlayerStats.update_exp()
