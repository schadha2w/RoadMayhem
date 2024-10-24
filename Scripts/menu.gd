extends Control

# All variables here
@onready var global = get_node("/root/Global")
@export var settings_ui : Node

@onready var play_button: Button = $MainMenu1/PlayButton
@onready var exit_button: Button = $MainMenu1/ExitButton
@onready var settings_button: Button = $MainMenu1/SettingsButton
@onready var music_player : AudioStreamPlayer2D = $Bgmusic
@onready var volume_slider : HSlider = $CanvasLayer/HSlider
@onready var fullscreen_check: CheckButton = $CanvasLayer/CheckButton
@onready var close_button : TextureButton = $CanvasLayer/TextureButton
@onready var button_sound_player: AudioStreamPlayer2D = $MainMenu1/AudioStreamPlayer2D
@onready var game_mode: OptionButton = $CanvasLayer/OptionButton


var first_load = true
var next_action: Callable = Callable()  


# Functions that run when game starts
func _ready() -> void:
	_load_settings()
	print(global.volume_setting)
	play_button.connect("pressed", Callable(self, "_on_play_button_pressed"))
	exit_button.connect("pressed", Callable(self, "_on_exit_button_pressed"))
	settings_button.connect("pressed", Callable(self, "_on_settings_button_pressed"))
	close_button.connect("pressed" , Callable(self, "_on_close_button_pressed"))
	volume_slider.connect("value_changed", Callable(self, "_on_volume_slider_changed"))
	button_sound_player.connect("finished", Callable(self, "_on_sound_finished"))
	
	settings_ui.visible = false
	
	volume_slider.min_value = 0
	volume_slider.max_value = 1
	volume_slider.step = 0.01
	volume_slider.value = music_player.volume_db
	volume_slider.value = global.volume_setting
	
	game_mode.add_item("Easy")
	game_mode.add_item("Normal")
	game_mode.add_item("Hard")
	game_mode.select(1)
	
	fullscreen_check.connect("toggled", Callable(self, "_on_fullscreen_toggled"))
	
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	fullscreen_check.button_pressed = is_fullscreen
	
	
	
# Takes all the inputs from the player
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("play"):
		_on_play_button_pressed()
		
	elif Input.is_action_pressed("settings"):
		_on_settings_button_pressed()
		
	elif Input.is_action_pressed("quit"):
		_on_exit_button_pressed()
		
	elif Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		
	elif Input.is_action_pressed("close"):
		_on_close_button_pressed()
		
		
# This function acts as a shortcut for fullscreen when "f" key is pressed. 
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		toggle_fullscreen()


func _on_game_mode_changed(index):
	# Get the selected item text
	var selected_text = game_mode.get_item_text(index)

	# Check the selected option and perform specific actions
	if selected_text == "Easy":
		print("Easy Mode selected")
		# Perform action for Easy Mode
		global.game_mode_global = 1

	elif selected_text == "Normal":
		print("Normal Mode selected")
		# Perform action for Normal Mode
		global.game_mode_global = 2

	elif selected_text == "Hard":
		print("Hard Mode selected")
		# Perform action for Hard Mode
		global.game_mode_global = 3
		
	else:
		print("error occoured")


# This function makes the window fullscreen when "f" button is pressed. 
func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
		
# This functions starts the gameplay when "Play Game" is pressed on the main menu. 
func _on_play_button_pressed() -> void:
	_play_button_sound()
	next_action = Callable(self, "_change_to_game_scene")


# This button quits the game when "Quit Game" is pressed on the main menu. 
func _on_exit_button_pressed() -> void:
	_play_button_sound()
	next_action = Callable(self, "_quit_game")


# This function opens the settings menu when "settings" button is pressed on the main menu. 
func _on_settings_button_pressed() -> void:
	_play_button_sound()
	next_action = Callable()
	print("Hello world")
	settings_ui.visible = true


# This function plays a sound when any button is pressed on any menus. 
func _play_button_sound() -> void:
	if button_sound_player.is_playing():
		button_sound_player.stop()
	button_sound_player.play()


# This function calls the next action when the sound effect is finished.
func _on_sound_finished() -> void:
	if next_action.is_valid():
		next_action.call()


# This function stars the game by switching to Main Game Scene when "Play Game" is pressed.
func _change_to_game_scene() -> void:
	get_tree().change_scene_to_file("res://scene/main.tscn")


# This function quits the game when "Quit Game" is pressed. 
func _quit_game() -> void:
	get_tree().quit()


# Settings of the game (this function is triggered when player changes the volume slider)
func _on_volume_slider_changed(value: float) -> void:
	if first_load:
		volume_slider.value = global.volume_setting
		first_load = false
	var volume_db = linear_to_db(value)
	music_player.volume_db = volume_db
	global.volume_setting = volume_slider.value
	_save_settings(global.volume_setting)
	
	
# This function changes to fullscreen when the fullscreen toggle is pressed in the settings. 
func _on_fullscreen_toggled(is_fullscreen: bool) -> void:
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		

# This function hides the settings menu UI
func _on_close_button_pressed() -> void:
	_play_button_sound()
	next_action = Callable(self, "_close_settings")
	

# This function is an extention to the hide sttings functions. 
func _close_settings() -> void:
	settings_ui.visible = false
	
	
# This function saves the settings prefrences of the user to a file on the user's computer
func _save_settings(settings):
	var file = FileAccess.open("user://settings.save", FileAccess.WRITE)
	if file:
		print("Saving settings", global.volume_setting)
		file.store_var(global.volume_setting)
		file.close()


# This function saves loads the settings prefrences of the user from file saved on computer. 
func _load_settings():
	var file = FileAccess.open("user://settings.save", FileAccess.READ)
	if file:
		var volume = file.get_var()
		print("volume" + str(volume))
		file.close()
		
		global.volume_setting = volume
		print("var " + str(global.volume_setting))
