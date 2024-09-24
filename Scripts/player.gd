extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var current_score = 0

@export var score_ui : Node


func _physics_process(delta: float) -> void:
	# Add the gravity.

	# Handle jump.
	velocity.y = -550.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func crash(body: Node2D) -> void:
	if body.has_meta("car"):
		get_tree().change_scene_to_file("res://Scene/menu.tscn") # Replace with function body.



func Score(body: Node2D) -> void:
	if body.has_meta("car"):
		current_score = current_score + 1 # Replace with function body.
		print(current_score)
		score_ui.text = "Score: " + str(current_score)
