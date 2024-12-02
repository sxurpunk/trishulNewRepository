extends Node2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_quit_pressed() -> void:
	get_tree().quit()
