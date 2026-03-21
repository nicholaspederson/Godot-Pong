extends CharacterBody2D

var maxVel = 300
var velocityBall = Vector2(maxVel, 0)

func _physics_process(delta):
	var collision = move_and_collide(velocityBall * delta)
	var screen_size = get_viewport_rect().size
	
	if collision:
		var paddle = collision.get_collider()
		
		if paddle.get_class() == "StaticBody2D":
			velocityBall = velocityBall.bounce(collision.get_normal())
			return
		
		# The ball is hitting a paddle
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
		
		maxVel += .1
		#velocityBall = velocityBall.bounce(collision.get_normal()) #-maxVel * cos(collision.get_angle(),) #collision.get_normal()) 
		#velocityBall = velocityBall.rotated(collision.get_angle())
		#velocity = velocity.reflect(Vector2(0,1))
