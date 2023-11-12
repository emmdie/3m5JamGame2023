extends Control

@onready var level = load(Autoload.get_level())

var onTitleScreen = true

func _on_about_button_pressed():
	OS.shell_open("https://github.com/emmdie/3m5JamGame2023")
	
func _on_quit_button_pressed():
	get_tree().quit()

var min_timer = 0.5
func _on_play_button_pressed():
	onTitleScreen = false
	$AudioStreamPlayer.stop()
	$PlaySoundPlayer.play()
	
	
	#await $PlaySoundPlayer.finished

func _process(delta):
	if $PlaySoundPlayer.playing:
		min_timer -= delta
		if min_timer <= 0.0:
			$PlaySoundPlayer.stop()
			level = level.instantiate()
			get_tree().root.add_child(level)
			queue_free()
			
	if !$AudioStreamPlayer.playing and onTitleScreen:
		$AudioStreamPlayer.play()
