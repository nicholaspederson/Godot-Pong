extends CharacterBody2D

var startVel = 500
var maxVel
var velocityBall

var player1score = 0
var player2score = 0

func reset_ball():
	position = Vector2(60200008.0,44900004.0)	
	maxVel = startVel
	velocityBall = Vector2(maxVel, 0)

func addpointtoplayer(player: int):
	match player:
		1:
			player1score += 1
		2:
			player2score += 1
	# update the Label
	var playerScore = get_node("/root/Root Node2D/CanvasLayer/Control/ScoreLabel") as Label
	playerScore.text = "Score " + str(player1score) + ":" + str(player2score)
	return

func _init() -> void:
	reset_ball()
	

func _physics_process(delta):
	var collision = move_and_collide(velocityBall * delta)
	
	if collision:
		var paddle = collision.get_collider()
		
		match paddle.get("collision_layer"):
			32: #went through right goal!
				reset_ball()
				addpointtoplayer(1)
			16: #left goal!
				addpointtoplayer(2)
				reset_ball()
			8: # The ball is hitting a wall
				velocityBall = velocityBall.bounce(collision.get_normal())
			2, 4: # The ball is hitting a paddle
				# Compute hit offset (-1 to +1)
				var shape := paddle.get_node("CollisionShape2D").shape as RectangleShape2D
				var offset = (position.y - paddle.position.y) / (shape.size.y / 2.0)
				offset = clamp(offset, -1.0, 1.0)

				# Convert to angle
				var max_angle = deg_to_rad(45)
				var angle = offset * max_angle

				# Reverse X direction and apply angle
				var direction = -sign(velocityBall.x)
				velocityBall = Vector2(
					direction * cos(angle),
					sin(angle)
				) * maxVel
				
				maxVel += 10
