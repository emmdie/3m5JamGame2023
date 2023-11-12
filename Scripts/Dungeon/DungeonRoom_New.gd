extends Control

@onready var enemies = $Enemies
@onready var player = $Player

# Called when the node enters the scene tree for the first time.

func _ready():
	for enemy in enemies.get_children():
		enemy.died.connect(_on_enemy_killed)

func _on_enemy_killed(EXP):
	player.give_exp(EXP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
