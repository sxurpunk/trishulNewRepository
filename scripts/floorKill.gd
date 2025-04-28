extends MeshInstance3D

@onready var pauseMenu: Control = $"../../CanvasLayer/Pause Menu"

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		get_tree().reload_current_scene()
		print ("sensed")
