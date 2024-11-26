extends CharacterBody3D

@onready var camera_holder: Node3D = $cameraHolder
@onready var animation_player: AnimationPlayer = $visuals/finalCombatTrishulAnimations/AnimationPlayer
@onready var visuals: Node3D = $visuals

var SPEED = 5.0
const JUMP_VELOCITY = 3

@export var walkSpeed = 5.0
@export var runSpeed = 10.0

var can_input = true

var isRunning = false

var isLocked = false

@export var horizontalSens = 0.5
@export var verticalSens = 0.5

var input_dir
var direction

var attacks : int = 1

var currentState = playerStates.MOVE
enum playerStates {MOVE, JUMP, ATTACK}

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*horizontalSens))
		camera_holder.rotate_x(deg_to_rad(-event.relative.y*verticalSens))
		camera_holder.rotation.x = clamp(camera_holder.rotation.x, deg_to_rad(-90), deg_to_rad(45))
		
	# Handle jump.
#		if Input.is_action_just_pressed("playerJump") and is_on_floor():
#			currentState = playerStates.JUMP
#		if Input.is_action_just_released("playerJump") and !is_on_floor():
#			currentState = playerStates.MOVE

func _physics_process(delta: float) -> void:
	
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	match currentState:
		playerStates.MOVE:
			move(delta)
#			playerStates.JUMP:
#				jump()

func move(_delta):
	
	if !animation_player.is_playing():
		isLocked = false;
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_pressed("playerRun"):
		SPEED = runSpeed
		isRunning = true
	else:
		SPEED = walkSpeed
		isRunning = false
	
	if is_on_floor():
		if direction:
			if !isLocked:
				if isRunning:
					if animation_player.current_animation != "running":
						animation_player.play("run")
				else:
					if animation_player.current_animation != "walking":
						animation_player.play("updatedwalk")
						
				visuals.look_at(position + direction)
				
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			if !isLocked:
				if animation_player.current_animation != "idle":
					animation_player.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
#		if !is_on_floor():
#			if direction:
#				if !isLocked:
#					if isRunning:
#						if animation_player.current_animation != "fall":
#							animation_player.play("fall")
#					else:
#						if animation_player.current_animation != "fall":
#							animation_player.play("fall")
#						
#					visuals.look_at(position + direction)
#					
#				velocity.x = direction.x * SPEED
#				velocity.z = direction.z * SPEED
#				
#			if !direction:
#				if !isLocked:
#					if animation_player.current_animation != "fall":
#						animation_player.play("fall")
#				velocity.x = move_toward(velocity.x, 0, SPEED)
#				velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if !isLocked:
		move_and_slide()

#	func jump():
#			velocity.y = JUMP_VELOCITY
#			if animation_player.current_animation != "jump":
#				animation_player.play("jump")
#			direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#		move_and_slide()

	if attacks == 1 && Input.is_action_just_pressed("playerAttack") && is_on_floor():
			if animation_player.current_animation != "attack1":
				animation_player.play("attack1")
				isLocked = true
				attacks += 1
	elif attacks == 2 and Input.is_action_just_pressed("playerAttack") && is_on_floor():
				animation_player.play("attack2")
				isLocked = true
				attacks += 1
	elif attacks == 2 and Input.is_action_just_pressed("playerAttack2") && is_on_floor():
				animation_player.play("heavyAttack1")
				isLocked = true
				attacks += 1
	elif attacks == 3 and Input.is_action_just_pressed("playerAttack") && is_on_floor():
				animation_player.play("attack3")
				isLocked = true
				attacks += 1
	elif attacks == 3 and Input.is_action_just_pressed("playerAttack2") && is_on_floor():
				animation_player.play("heavyAttack2")
				isLocked = true
				attacks += 1
	elif attacks == 4 and Input.is_action_just_pressed("playerAttack") && is_on_floor():
				animation_player.play("attack4")
				isLocked = true
	elif attacks == 4 and Input.is_action_just_pressed("playerAttack2") && is_on_floor():
				animation_player.play("heavyAttack3")
				isLocked = true

func resetState():
	currentState = playerStates.MOVE
	
func resetAttack():
	attacks = 1

func readyForInput():
	can_input = true

func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.has_method("hurt"):
		body.hurt()
