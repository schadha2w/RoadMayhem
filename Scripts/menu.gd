extends Control

@onready var play_button: Button = $MainMenu1/PlayButton
@onready var exit_button: Button = $MainMenu1/ExitButton

func _ready() -> void:
	# Connect button signals
	play_button.connect("pressed", Callable(self, "_on_play_button_pressed"))
	exit_button.connect("pressed", Callable(self, "_on_exit_button_pressed"))

func _on_play_button_pressed() -> void:
	# Load the game scene
	get_tree().change_scene_to_file("res://scene/main.tscn")  # Change this to your actual game scene path

func _on_exit_button_pressed() -> void:
	# Exit the game
	get_tree().quit()
