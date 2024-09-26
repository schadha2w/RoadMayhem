extends Node2D

@onready var points = [$Camera2D/spawn_one, $Camera2D/spawn_two, $Camera2D/spawn_three]

@onready var restart_button : TextureButton = $CanvasLayer2/RestartButton
@onready var mainmenu_button : TextureButton = $CanvasLayer2/MainMenuButton

@onready var button_sound_player: AudioStreamPlayer2D = $CanvasLayer2/AudioStreamPlayer2D
@export var car_scene : PackedScene

var rand = RandomNumberGenerator.new()
var next_action: Callable = Callable()  


func _ready():
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	mainmenu_button.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))
	button_sound_player.connect("finished", Callable(self, "_on_sound_finished"))
	



func _on_area_entered(area: Area2D) -> void:
	var point = points[rand.randi_range(0,2)]
	var car = car_scene.instantiate()
	car.global_position = point.global_position
	add_child(car)
	
func _play_button_sound() -> void:
	if button_sound_player.is_playing():
		button_sound_player.stop()
	button_sound_player.play()
	
func _on_restart_button_pressed():
	_play_button_sound()
	next_action = Callable(self, "restart_the_game")
	
	
func _on_main_menu_button_pressed():
	_play_button_sound()
	next_action = Callable(self, "_change_to_menu_scene")
	
	
func _on_sound_finished() -> void:
	if next_action.is_valid():
		next_action.call()
		
func restart_the_game() -> void:
	print("yeah it works")
	get_tree().paused = false
	get_tree().reload_current_scene()
	
	
func _change_to_menu_scene() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
