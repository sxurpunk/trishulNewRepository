class_name enemy
extends CharacterBody3D

@onready var nav = $bull_enemy/NavigationAgent3D

@onready var playerScript

@onready var visuals: Node3D = $bull_enemy/Armature_003

@onready var animation_player: AnimationPlayer = $bull_enemy/AnimationPlayer

@onready var damageIndicator: Sprite2D = $"../CanvasLayer/Ff0000"

var isLocked = false

var enemySpeed = 0.75
var gravity = 9.8
var health = 100

func _ready():
	damageIndicator.self_modulate.a = 0.25

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
	
	moveToPlayer(delta)

func die():
	playerScript.killCount += 1
	queue_free()

func hurt():
	health -= 25

func target_position(target):
	nav.target_position = target

func attackPlayer():
	animation_player.play("attack")
	isLocked = true


func moveToPlayer(delta:float):
	if playerScript != null && !isLocked:
		self.global_position=lerp(self.global_position, playerScript.global_position, enemySpeed * delta)
#		var old_rot = self.rotation
		self.look_at(playerScript.global_position)
		#		self.rotation.y = old_rot.y
		
		animation_player.play("walk")

func _on_attackTrigger_entered(body: Node3D) -> void:
	if body is Player:
		attackPlayer()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		playerScript = body

func _on_hitbox_body_entered(body: Node3D) -> void:
	if body is Player:
		playerScript.playerHealth -= 50
		showDamage()
		print("doing damage")

func showDamage():
	damageIndicator.visible = true

func hideDamage():
	damageIndicator.visible = false
