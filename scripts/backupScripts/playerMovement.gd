extends CharacterBody3D

@onready var camera_holder: Node3D = $cameraHolder
@onready var animation_player: AnimationPlayer = $visuals/baseCharacterModel/AnimationPlayer
@onready var visuals: Node3D = $visuals

var SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var walkSpeed = 4.0
@export var runSpeed = 6.0

var isRunning = false

var isLocked = false

@export var horizontalSens = 0.5
@export var verticalSens = 0.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*horizontalSens))
		camera_holder.rotate_x(deg_to_rad(-event.relative.y*verticalSens))
		camera_holder.rotation.x = clamp(camera_holder.rotation.x, deg_to_rad(-90), deg_to_rad(45))

func _physics_process(delta: float) -> void:
	
	if !animation_player.is_playing():
		isLocked = false;
	
	if Input.is_action_pressed("playerAttack") and is_on_floor():
			if animation_player.current_animation != "kick":
				animation_player.play("kick")
				isLocked = true
	
	if Input.is_action_pressed("playerRun"):
		SPEED = runSpeed
		isRunning = true
	else:
		SPEED = walkSpeed
		isRunning = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("playerJump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if animation_player.current_animation != "jump":
			animation_player.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("moveLeft", "moveRight", "moveForward", "moveBackward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !isLocked:
			if isRunning:
				if animation_player.current_animation != "running":
					animation_player.play("run")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walk")
					
			visuals.look_at(position + direction)
			
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if !isLocked:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if !isLocked:
		move_and_slide()
