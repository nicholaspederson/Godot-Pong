extends CharacterBody2D
var speed = 300

func get_input():
	var input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	#Input.get_vector("move", "d", "w", "ui_down")
	input_dir.x = 0
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
