extends Control

@onready var level = preload(Autoload.level)

func _on_about_button_pressed():
	OS.shell_open("https://github.com/emmdie/3m5JamGame2023")
	
func _on_quit_button_pressed():
	get_tree().quit()

func _on_play_button_pressed():
	level = level.instantiate()
	get_tree().root.add_child(level)
	queue_free()

