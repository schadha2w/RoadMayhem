extends CanvasLayer

@onready var restart_button : TextureButton = $RestartButton
@onready var mainmenu_button : TextureButton = $MainMenuButton
@onready var button_sound_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var next_action: Callable = Callable()


# This function runs when the game starts 
func _ready():
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	mainmenu_button.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))
	button_sound_player.connect("finished", Callable(self, "_on_sound_finished"))


# This function takes input from the user for the shortcuts assigned from the user's keyboard 
# And triggers a particular function
func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("restart"):
		_on_restart_button_pressed()
		
	elif Input.is_action_pressed("menu"):
		_on_main_menu_button_pressed()
		
	elif Input.is_action_pressed("quit"):
		get_tree().quit()
		
		
# This runs when restart button is pressed
func _on_restart_button_pressed():
	_play_button_sound()
	next_action = Callable(self, "restart_the_game")
	

# This runs when the main menu button is pressed
func _on_main_menu_button_pressed():
	_play_button_sound()
	next_action = Callable(self, "_change_to_menu_scene")
	

# This runs the sound effect when a button is pressed 
func _play_button_sound() -> void:
	if button_sound_player.is_playing():
		button_sound_player.stop()
	button_sound_player.play()
	

# This function calls the next action when the sound effect is finished
func _on_sound_finished() -> void:
	if next_action.is_valid():
		next_action.call()
		

# This function restarts the game. 
func restart_the_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
	
# This function redirects the user to the main menu
func _change_to_menu_scene() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
