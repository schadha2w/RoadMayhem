extends Node2D

@onready var points = [$Camera2D/spawn_one, $Camera2D/spawn_two, $Camera2D/spawn_three]

@onready var restart_button : TextureButton = $CanvasLayer2/RestartButton
@onready var mainmenu_button : TextureButton = $CanvasLayer2/MainMenuButton

@export var car_scene : PackedScene

var rand = RandomNumberGenerator.new()

func _ready():
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	mainmenu_button.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))


func _on_area_entered(area: Area2D) -> void:
	var point = points[rand.randi_range(0,2)]
	var car = car_scene.instantiate()
	car.global_position = point.global_position
	add_child(car)
	
func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
