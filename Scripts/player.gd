extends CharacterBody2D


var current_speed = 0.0  
var acceleration = 200.0 
var deceleration = 150.0  
var max_speed = 5500.0  
var min_speed = 50.0  
var current_score = 0  

@export var score_ui : Node  

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
		get_tree().change_scene_to_file("res://Scene/menu.tscn")

func Score(body: Node2D) -> void:
	if body.has_meta("car"):
		current_score += 1  
		print(current_score)
		score_ui.text = "Score: " + str(current_score)
