extends Control

# Reference buttons
@onready var play_button: Button = $MainMenu1/PlayButton
@onready var exit_button: Button = $MainMenu1/ExitButton
@onready var settings_button: Button = $MainMenu1/SettingsButton

# Reference the AudioStreamPlayer node (ensure path is correct)
@onready var button_sound_player: AudioStreamPlayer2D = $MainMenu1/AudioStreamPlayer2D  # Adjust path if necessary

func _ready() -> void:
	print(button_sound_player)  # Debugging to ensure the AudioStreamPlayer is found
	# Connect button signals
	play_button.connect("pressed", Callable(self, "_on_play_button_pressed"))
	exit_button.connect("pressed", Callable(self, "_on_exit_button_pressed"))
	settings_button.connect("pressed", Callable(self, "_on_settings_button_pressed"))

func _on_play_button_pressed() -> void:
	_play_button_sound()
	get_tree().change_scene_to_file("res://scene/main.tscn")  # Update with your game scene path

func _on_exit_button_pressed() -> void:
	_play_button_sound()
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	_play_button_sound()
	print("Settings button pressed")  # Placeholder for settings menu action

# Helper function to play the button sound
func _play_button_sound() -> void:
	if button_sound_player.is_playing():
		button_sound_player.stop()
	button_sound_player.play()
