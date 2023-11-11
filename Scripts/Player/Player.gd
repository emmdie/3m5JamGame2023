extends Area2D


@onready var walkable_ray = $PlayerWalkableChecker
var tile_size = 64
var inputs = {"RIGHT": Vector2.RIGHT,
			"LEFT": Vector2.LEFT,
			"UP": Vector2.UP,
			"DOWN": Vector2.DOWN}
var animation_speed = 6
var moving = false

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2

#checks if the player is allowed to move
func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

#moves and animates the movement
func move(dir):
	walkable_ray.target_position = inputs[dir] * tile_size
	walkable_ray.force_raycast_update()
	if walkable_ray.is_colliding():
		var tween = create_tween()
		tween.finished.connect(_on_tween_finished)
		tween.tween_property(self, "position",
			position + inputs[dir] *    tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true

#erlaubt den Spieler nach abspielen der Animation wieder zu bewegen
func _on_tween_finished():
	moving = false



func _process(_delta):
	pass
