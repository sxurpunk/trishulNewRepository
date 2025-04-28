class_name Player
extends CharacterBody3D

@onready var camera_holder: Node3D = $cameraHolder
@onready var animation_player: AnimationPlayer = $visuals/finalCombatTrishulAnimations/AnimationPlayer
@onready var visuals: Node3D = $visuals
# @onready var healthbar = $CanvasLayer/Healthbar

@onready var enemyScript = $"../enemy"

@onready var target = $"."

var health = 500
var SPEED = 5.0
var projectileCost = 0.0
const JUMP_VELOCITY = 3

@onready var marker_3d: Marker3D = $Marker3D
const PROJECTILE_SCENE = preload("res://scenes/projectileScene.tscn")

@export var walkSpeed = 6.0
@export var runSpeed = 12.0
@onready var walking_sound: AudioStreamPlayer3D = $walkingSound
@onready var attack_sound_1: AudioStreamPlayer3D = $attackSound1

var isRunning = false

var isLocked = false

var readyForInput = false

var isPlayerDead : int = 0

@export var horizontalSens = 0.5
@export var verticalSens = 0.5

var input_dir
var direction

var attacks : int = 1

var currentState = playerStates.MOVE
enum playerStates {MOVE, JUMP, ATTACK}

#func sensePlayer():
#	get_tree().call_group("enemy", "target_position" , target.global_transform.origin)
#	print("unity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health = 100
	# healthbar.init_health(health)

#func _quitGame():
#	if Input.is_action_pressed("quit"):
#		get_tree().quit()

func _die():
	if health <= 0 || Input.is_action_just_pressed("die"):
		isLocked = true
		animation_player.play("death")
	elif isPlayerDead == 1:
		animation_player.play("stayDead")
		isLocked = true

func _addDeath():
	isPlayerDead = 1

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*horizontalSens))
		camera_holder.rotate_x(deg_to_rad(-event.relative.y*verticalSens))
		camera_holder.rotation.x = clamp(camera_holder.rotation.x, deg_to_rad(-40), deg_to_rad(35))
		
	# Handle jump.
#		if Input.is_action_just_pressed("playerJump") and is_on_floor():
#			currentState = playerStates.JUMP
#		if Input.is_action_just_released("playerJump") and !is_on_floor():
#			currentState = playerStates.MOVE

func _physics_process(delta: float) -> void:
	
#	if Input.is_action_just_pressed("shoot"):
#		_shoot_projectile()
	
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
				$attackSound1.play()
				isLocked = true
				attacks += 1
	elif attacks == 2 and readyForInput == true and Input.is_action_just_pressed("playerAttack") && is_on_floor():
				animation_player.play("attack2")
				$attackSound1.play()
				isLocked = true
				attacks += 1
	elif attacks == 2 and readyForInput == true and Input.is_action_just_pressed("playerAttack2") && is_on_floor():
				animation_player.play("heavyAttack1")
				isLocked = true
				resetAttack()
	elif attacks == 3 and readyForInput == true and Input.is_action_just_pressed("playerAttack") && is_on_floor():
				animation_player.play("attack3")
				$attackSound1.play()
				isLocked = true
				attacks += 1
	elif attacks == 3 and readyForInput == true and Input.is_action_just_pressed("playerAttack2") && is_on_floor():
				animation_player.play("heavyAttack2")
				isLocked = true
				resetAttack()
	elif attacks == 4 and readyForInput == true and Input.is_action_just_pressed("playerAttack") && is_on_floor():
				animation_player.play("attack4")
				$attackSound1.play()
				isLocked = true
	elif attacks == 4 and readyForInput == true and Input.is_action_just_pressed("playerAttack2") && is_on_floor():
				animation_player.play("heavyAttack3")
				isLocked = true
				resetAttack()
	
	_die()

func resetState():
	currentState = playerStates.MOVE
	
func resetAttack():
	attacks = 1

func resetProjectile():
	projectileCost = 0;

func comboChain():
	readyForInput = true

func comboBreak():
	readyForInput = false

func playAttackSound():
	$attackSound1.play()

func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.has_method("hurt"):
		body.hurt()
		projectileCost += 25

#func _shoot_projectile():
#	if projectileCost > 100:
#		visuals.look_at(position + direction)
#		var projectile_node = PROJECTILE_SCENE.instantiate()
#		get_parent().add_child(projectile_node)
#		projectile_node.global_position = marker_3d.global_position
#		resetProjectile()

#func _on_area_3d_body_entered(body: Node3D) -> void:
#	if body is enemy:
#		enemyScript.attackPlayer()

	#func _set_health(value):
#		if health <= 0:
#			$".".queue_free()
#		
#		healthbar.health = health
