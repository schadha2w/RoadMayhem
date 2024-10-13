extends CharacterBody2D

@onready var global = get_node("/root/Global")

var current_speed = 0.0  
var acceleration = 200.0 
var deceleration = 150.0  
var max_speed = 10000.0  
var min_speed = 1000.0  
var current_score = 0  

@export var score_ui : Node
@export var game_over_ui : Node
@export var final_score_label : Node
@export var high_score_label : Node

func _ready():
	game_over_ui.visible = false
	
	

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("ui_up"):
		current_speed += acceleration * delta
	else:
		current_speed -= deceleration * delta
	
	
	current_speed = clamp(current_speed, min_speed, max_speed)

	
	var direction := Input.get_axis("ui_left", "ui_right")
	
	
	velocity.x = direction * current_speed

	
	velocity.y = current_speed * -1  

	
	move_and_slide()

func crash(body: Node2D) -> void:
	if body.has_meta("car"):
		show_game_over()
		
func show_game_over():
	get_tree().paused = true
	
	score_ui.visible = false
	
	game_over_ui.visible=true
	
	final_score_label.text = "Final Score: " + str(current_score)
	if current_score > global.high_score:
		global.high_score = current_score
		print(global.high_score)
		
	high_score_label.text = "High Score: " + str(global.high_score)

func Score(body: Node2D) -> void:
	if body.has_meta("car"):
		current_score += 1  
		print(current_score)
		score_ui.text = "Score: " + str(current_score)
