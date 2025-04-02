class_name enemy
extends CharacterBody3D

@onready var nav = $NavigationAgent3D

@onready var playerScript = $"../PlayerScene"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var isLocked = false


var enemySpeed = 3.5
var gravity = 9.8
var health = 100

func _process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y -= 2
	var next_location = nav.get_next_path_position()
	var current_location = global_transform.origin
	var new_velocity = (next_location - current_location).normalized() * enemySpeed
	
	velocity = velocity.move_toward(new_velocity, 0.25)
	
	if health <= 0:
		die()
	
	if !animation_player.is_playing():
		isLocked = false;
	
	if !isLocked:
		move_and_slide()

func die():
	call_deferred("free")

func hurt():
	health -= 25

func target_position(target):
	nav.target_position = target

func attackPlayer():
	animation_player.play("enemyAttack")
	isLocked = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		playerScript.sensePlayer()
