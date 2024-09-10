extends Control

# Reference buttons
@onready var play_button: Button = $MainMenu1/PlayButton
@onready var exit_button: Button = $MainMenu1/ExitButton
@onready var settings_button: Button = $MainMenu1/SettingsButton

# Reference the AudioStreamPlayer2D node inside MainMenu1
@onready var button_sound_player: AudioStreamPlayer2D = $MainMenu1/AudioStreamPlayer2D

# To store the next action after the sound finishes
var next_action: Callable = Callable()  # Use an empty Callable as the default

func _ready() -> void:
	# Debugging to ensure nodes are correctly referenced
	print("Play button:", play_button)
	print("Exit button:", exit_button)
	print("Settings button:", settings_button)
	print("AudioStreamPlayer2D:", button_sound_player)
	
	# Connect button signals
	play_button.connect("pressed", Callable(self, "_on_play_button_pressed"))
	exit_button.connect("pressed", Callable(self, "_on_exit_button_pressed"))
	settings_button.connect("pressed", Callable(self, "_on_settings_button_pressed"))
	
	# Connect the finished signal of the AudioStreamPlayer2D to handle when the sound is done
	button_sound_player.connect("finished", Callable(self, "_on_sound_finished"))

func _on_play_button_pressed() -> void:
	_play_button_sound()
	next_action = Callable(self, "_change_to_game_scene")

func _on_exit_button_pressed() -> void:
	_play_button_sound()
	next_action = Callable(self, "_quit_game")

func _on_settings_button_pressed() -> void:
	_play_button_sound()
	next_action = Callable()  # No action needed, so assign an empty Callable

# Helper function to play the button sound
func _play_button_sound() -> void:
	if button_sound_player.is_playing():
		button_sound_player.stop()
	button_sound_player.play()

# Called when the sound finishes playing
func _on_sound_finished() -> void:
	if next_action.is_valid():
		next_action.call()

# Change to the main game scene
func _change_to_game_scene() -> void:
	get_tree().change_scene_to_file("res://scene/main.tscn")

# Quit the game
func _quit_game() -> void:
	get_tree().quit()
