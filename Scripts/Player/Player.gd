extends Area2D


@onready var walkable_ray = $PlayerWalkableChecker
@onready var attack_ray = $PlayerAttackDirection
@onready var tongue = $PlayerTongue
var tile_size = 64
var arrow_keys = {"RIGHT": Vector2.RIGHT,
			"LEFT": Vector2.LEFT,
			"UP": Vector2.UP,
			"DOWN": Vector2.DOWN}
var wasd = {"W": Vector2.RIGHT,
			"A": Vector2.LEFT,
			"S": Vector2.UP,
			"D": Vector2.DOWN}

var walking_animation_speed = 6
var tongue_animation_reach = 2.5
var tongue_animation_speed =6

var moving = false

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

#checks if the player is allowed to move
func _unhandled_input(event):
	if moving:
		return
	for dir in arrow_keys.keys():
		if event.is_action_pressed(dir):
			move(dir)
	for dir in wasd.keys():
		if event.is_action_pressed(dir):
			attack(dir)

#moves and animates the movement
func move(dir):
	walkable_ray.target_position = arrow_keys[dir] * tile_size
	walkable_ray.force_raycast_update()
	if walkable_ray.is_colliding():
		var tween = create_tween()
		tween.finished.connect(_on_moving_tween_finished)
		tween.tween_property(self, "position",position + arrow_keys[dir] *    tile_size, 1.0/walking_animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true

#erlaubt den Spieler nach abspielen der Animation wieder zu bewegen
func _on_moving_tween_finished():
	moving = false

func attack(dir):
	attack_ray.target_position = wasd[dir] * tile_size
	attack_ray.force_raycast_update()
	if dir == "D":
		tongue.flip_v = false
		tongue.rotation = 0
		stretch_tongue()
		tongue.flip_v = true
	if dir == "W":
		tongue.rotation = -0.5*PI
		tongue.show()
		stretch_tongue()
	if dir == "A":
		tongue.flip_h = true
		tongue.rotation = -PI
		tongue.show()
		stretch_tongue()
		tongue.flip_h = false
	if dir == "S":
		tongue.rotation = 0.5*PI
		stretch_tongue()

func stretch_tongue():
	var tween = create_tween()
	tween.finished.connect(_on_tongue_tween_finished)
	tween.tween_property(tongue,"scale",Vector2(tongue_animation_reach,1), 1.0/tongue_animation_speed).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(tongue,"scale",Vector2(1,1), 1.0/tongue_animation_speed).set_trans(Tween.TRANS_LINEAR)
	
func _on_tongue_tween_finished():
	moving = false

func _process(_delta):
	pass
