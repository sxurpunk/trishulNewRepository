extends Node3D

@export var health = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 100
	$"../Label".text = str(health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hurt():
	health -= 5
	$"../Label".text = str(health)
