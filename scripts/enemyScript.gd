extends CharacterBody3D

var player = null
var state_machine

const SPEED = 3.0
const ATTACK_RANGE = 2.5

@export var health = 100
@export var player_path : NodePath

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var can_attack = true

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	health = 100
	$"../Label".text = str(health)

func hurt():
	health -= 5
	$"../Label".text = str(health)

func pause():
	animation_player.play("idle")

func _process(_delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"run":
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP)
		"attack":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/run", !_target_in_range())
	
	anim_tree.get("parameters/playback")
	
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
