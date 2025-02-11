extends Node2D

# All variables here
@onready var global = get_node("/root/Global")
@onready var points = [$Camera2D/spawn_one, $Camera2D/spawn_two, $Camera2D/spawn_three]
@onready var restart_button : TextureButton = $CanvasLayer2/RestartButton
@onready var mainmenu_button : TextureButton = $CanvasLayer2/MainMenuButton
@onready var button_sound_player: AudioStreamPlayer2D = $CanvasLayer2/AudioStreamPlayer2D
@export var car_scene : PackedScene

var rand = RandomNumberGenerator.new()
var next_action: Callable = Callable()  


# This function runs when the gameplay starts
func _ready():
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	mainmenu_button.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))
	button_sound_player.connect("finished", Callable(self, "_on_sound_finished"))
	_load_high_score()
	_load_settings()
	
	
# This function takes all the inputs from the user on the game over menu.
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("restart"):
		_on_restart_button_pressed()
		
	elif Input.is_action_pressed("menu"):
		_on_main_menu_button_pressed()
		
	elif Input.is_action_pressed("quit"):
		get_tree().quit()


# This function spawns the enemy cars which the user has to dodge. 
func _on_area_entered(area: Area2D) -> void:
	var point = points[rand.randi_range(0,2)]
	var car = car_scene.instantiate()
	car.global_position = point.global_position
	add_child(car)
	
	
# This function plays the button sound when a button is pressed. 
func _play_button_sound() -> void:
	if button_sound_player.is_playing():
		button_sound_player.stop()
	button_sound_player.play()
	
	
# This function restars the game when restart button is pressed on the game over menu. 
func _on_restart_button_pressed():
	_play_button_sound()
	next_action = Callable(self, "restart_the_game")
	
	
# This function redirects to the main menu when the main menu button is pressed
func _on_main_menu_button_pressed():
	_play_button_sound()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
	#next_action = Callable(self, "_change_to_menu_scene")
	
	
# This function is an extention for the button sound function
func _on_sound_finished() -> void:
	if next_action.is_valid():
		next_action.call()
		
	
# This function is needed to restart the game
func restart_the_game() -> void:
	pass
	
	
# This function takes the user back to the main menu from the game over menu.
func _change_to_menu_scene() -> void:
	pass


# This function reads the file on the user's device and loads the previous high score 
# So the high score isn't lost when the user closes the game
func _load_high_score():
	var file = FileAccess.open("user://high_score.save", FileAccess.READ)
	if file:
		var highscore = file.get_32()
		print(highscore)
		file.close()
		global.high_score = highscore
		
		
# This function reads the file on the user's device and loads the user's settings prefrences
# So the user's prefrences aren't lost when the user closes the game. 
func _load_settings():
	var file = FileAccess.open("user://settings.save", FileAccess.READ)
	if file:
		var volume = file.get_var()
		print("volume" + str(volume))
		file.close()
		global.volume_setting = volume
		print("var " + str(global.volume_setting))
		
		
# This function just takes the input of the user when turning fullscreen. 
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		toggle_fullscreen()


# This function toggles the fullscreen
func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
