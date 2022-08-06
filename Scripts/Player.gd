extends KinematicBody2D

# --- Player Movement ---
const ACCELERATION = 500 #rate to arrive at max speed
const MAX_SPEED = 80
const FRICTION = 500 #rate to arrive at stop

var velocity = Vector2.ZERO


func _physics_process(delta):
	# --- Player Input ---
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# --- Resolving Velocity / Animation ---
	if input_vector != Vector2.ZERO: #if player is moving
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else: # or if player is still
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) #come to stop at rate of friction
		
	velocity = move_and_slide(velocity)
