extends KinematicBody2D

# --- Player Movement ---
const ACCELERATION = 400 #rate to arrive at max speed
const MAX_SPEED = 80
const FRICTION = 350 #rate to arrive at stop

var velocity = Vector2.ZERO

# --- Player Animation ---
onready var animationPlayer = $PlayerAnimationPlayer # '$' gets access to child node by name (string)
onready var animationTree = $PlayerAnimationTree
onready var animationState = animationTree.get("parameters/playback")

# --- State Machine ---
enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE





func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state: #if the state matches, do this
		MOVE: 
			move_state(delta)
			
		ROLL:
			pass
			
		ATTACK:
			attack_state(delta)


func move_state(delta):
	# --- Player Input ---
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# --- Resolving Velocity / Animation ---
	if input_vector != Vector2.ZERO: #if player is moving
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else: # or if player is still
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) #come to stop at rate of friction
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_animation_finished(): #referenced in animation player. changes state after attack frames are done
	state = MOVE
