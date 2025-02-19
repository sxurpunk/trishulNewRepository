extends CSGBox3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func hurt():
	animation_player.play("takeHit")
