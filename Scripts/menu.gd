extends Control


@onready var play_button: Button = $MainMenu1/PlayButton
@onready var exit_button: Button = $MainMenu1/ExitButton
@onready var settings_button: Button = $MainMenu1/SettingsButton


@onready var button_sound_player: AudioStreamPlayer2D = $MainMenu1/AudioStreamPlayer2D


var next_action: Callable = Callable()  

func _ready() -> void:
	
	play_button.connect("pressed", Callable(self, "_on_play_button_pressed"))
	exit_button.connect("pressed", Callable(self, "_on_exit_button_pressed"))
	settings_button.connect("pressed", Callable(self, "_on_settings_button_pressed"))
	
	
	button_sound_player.connect("finished", Callable(self, "_on_sound_finished"))
	
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("play"):
		_on_play_button_pressed()
		
	elif Input.is_action_pressed("settings"):
		_on_settings_button_pressed()
		
	elif Input.is_action_pressed("quit"):
		_on_exit_button_pressed()

func _on_play_button_pressed() -> void:
	_play_button_sound()
	next_action = Callable(self, "_change_to_game_scene")

func _on_exit_button_pressed() -> void:
	_play_button_sound()
	next_action = Callable(self, "_quit_game")

func _on_settings_button_pressed() -> void:
	_play_button_sound()
	next_action = Callable()
	print("Hello world")


func _play_button_sound() -> void:
	if button_sound_player.is_playing():
		button_sound_player.stop()
	button_sound_player.play()


func _on_sound_finished() -> void:
	if next_action.is_valid():
		next_action.call()


func _change_to_game_scene() -> void:
	get_tree().change_scene_to_file("res://scene/main.tscn")


func _quit_game() -> void:
	get_tree().quit()
