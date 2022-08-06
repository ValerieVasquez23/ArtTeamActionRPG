extends KinematicBody2D

const ACCELERATION = 400 #rate to arrive at max speed
const MAX_SPEED = 80
const FRICTION = 350 #rate to arrive at stop


var velocity = Vector2.ZERO

func _physics_process(delta):
	
	#player input
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	#solving velocity
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) #move to stop at rate of friction
	
	move_and_collide(velocity * delta) #multiplying by delta makes the velocity relative to framerate
