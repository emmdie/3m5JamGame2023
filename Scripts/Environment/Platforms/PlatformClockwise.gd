extends Platform

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass


func _change_direction():
	match direction:
		Vector2.DOWN:
			direction = Vector2.LEFT
		Vector2.RIGHT:
			direction = Vector2.DOWN
		Vector2.UP:
			direction = Vector2.RIGHT
		Vector2.LEFT:
			direction = Vector2.UP
