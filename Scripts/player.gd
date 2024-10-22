extends CharacterBody2D

# All variables here
@onready var global = get_node("/root/Global")
@onready var crash_sound : AudioStreamPlayer2D = $AudioStreamPlayer2D

var current_speed = 0.0  
var acceleration = 20.0 
var max_speed = 10000.0  
var min_speed = 1000.0  
var current_score = 0  
@export var score_ui : Node
@export var game_over_ui : Node
@export var final_score_label : Node
@export var high_score_label : Node


# This function runs when the game starts. 
func _ready():
	game_over_ui.visible = false
	crash_sound.process_mode = Node.PROCESS_MODE_ALWAYS
	

# This function is respinsible for the movement of the car.
# It takes input from the user of weather the car is going left or right and folllows it. 
func _physics_process(delta: float) -> void:
	
	current_speed += acceleration * delta

	current_speed = clamp(current_speed, min_speed, max_speed)
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * current_speed
	velocity.y = current_speed * -1  
	move_and_slide()


# This function runs when the car crashed into another car. 
func crash(body: Node2D) -> void:
	if body.has_meta("car"):
		show_game_over()
		

# This function is shows the game over menu when the player crashes. 
func show_game_over():
	crash_sound.play()
	get_tree().paused = true
	
	score_ui.visible = false
	
	game_over_ui.visible=true
	
	final_score_label.text = "Final Score: " + str(current_score)
	if current_score > global.high_score:
		global.high_score = current_score
		print(global.high_score)
		
	high_score_label.text = "High Score: " + str(global.high_score)
	
	_save_high_score(global.high_score)


# This function shows the user their current score and updates in real time. 
func Score(body: Node2D) -> void:
	if body.has_meta("car"):
		current_score += 1  
		print(current_score)
		score_ui.text = "Score: " + str(current_score)
		
		
# saves high score in user's device
func _save_high_score(highScore):
	var file = FileAccess.open("user://high_score.save", FileAccess.WRITE)
	if file:
		print("Saving high score", global.high_score)
		file.store_32(global.high_score)
		file.close()
