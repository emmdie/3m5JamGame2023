extends Control

func show_game_over():
	visible = true
	$DeathAudio.play()
	get_tree().paused = true

	
func _on_main_menu_pressed():
	self.hide()
	get_viewport().get_camera_2d().enabled = false
	PlayerStats.reset_player_progress()
	get_tree().change_scene_to_file(Autoload.title_screen)
	get_tree().paused = false
