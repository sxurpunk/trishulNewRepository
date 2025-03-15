extends Area3D

@onready var playerScript = $"../../PlayerScene"

func _on_body_entered(body: Node3D) -> void:
	if body.call_group("player"):
		playerScript.sensePlayer()
