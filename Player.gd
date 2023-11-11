extends Area2D

@onready var ray = $PlayerCollisionChecker
var tile_size = 64
var inputs = {"RIGHT": Vector2.RIGHT,
			"LEFT": Vector2.LEFT,
			"UP": Vector2.UP,
			"DOWN": Vector2.DOWN}
var animation_speed = 3
var moving = false

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2


func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		var tween = create_tween()
		tween.finished.connect(_on_tween_finished)
		tween.tween_property(self, "position",
			position + inputs[dir] *    tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true

func _on_tween_finished():
	moving = false


func _process(delta):
	pass
