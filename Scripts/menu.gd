extends Control


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


var next_action: Callable = Callable()  

func _ready() -> void:
	
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
	global.volume_setting = volume_slider.value
	
	fullscreen_check.connect("toggled", Callable(self, "_on_fullscreen_toggled"))
	fullscreen_check.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	
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
		
	elif Input.is_action_pressed("fullscreen"):
		_on_fullscreen_toggled(true)

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
	settings_ui.visible = true


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
	
func _on_volume_slider_changed(value: float) -> void:
	var volume_db = linear_to_db(value)
	music_player.volume_db = volume_db
	
func _on_fullscreen_toggled(is_fullscreen: bool) -> void:
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
func _on_close_button_pressed() -> void:
	_play_button_sound()
	next_action = Callable(self, "_close_settings")
	print("Hello")
	
func _close_settings() -> void:
	settings_ui.visible = false
