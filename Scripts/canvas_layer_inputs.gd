extends CanvasLayer

@onready var restart_button : TextureButton = $RestartButton
@onready var mainmenu_button : TextureButton = $MainMenuButton
@onready var button_sound_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var next_action: Callable = Callable()

func _ready():
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	mainmenu_button.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))
	button_sound_player.connect("finished", Callable(self, "_on_sound_finished"))

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("restart"):
		_on_restart_button_pressed()
		
	elif Input.is_action_pressed("menu"):
		_on_main_menu_button_pressed()
		
	elif Input.is_action_pressed("quit"):
		get_tree().quit()
		
		
func _on_restart_button_pressed():
	_play_button_sound()
	next_action = Callable(self, "restart_the_game")
	
	
func _on_main_menu_button_pressed():
	_play_button_sound()
	next_action = Callable(self, "_change_to_menu_scene")
	

func _play_button_sound() -> void:
	if button_sound_player.is_playing():
		button_sound_player.stop()
	button_sound_player.play()
	

func _on_sound_finished() -> void:
	if next_action.is_valid():
		next_action.call()
		
func restart_the_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
	
func _change_to_menu_scene() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/menu.tscn")
