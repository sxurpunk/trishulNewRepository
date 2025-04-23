extends Control

var progress_bar_value: float = 0.0

@onready var PauseMenu = $PanelContainer/PauseMenu
@onready var SaveMenu = $PanelContainer/SaveMenu

func _ready() -> void:
	hide()
	$AnimationPlayer.play("RESET")

func resume():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	show()
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("Escape") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("Escape") and get_tree().paused == true:
		resume()


func _on_resume_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta: float) -> void:
	testEsc()


func _on_save_pressed() -> void:
	PauseMenu.hide()
	SaveMenu.show()


func _on_yes_pressed() -> void:
	SaveLoad.contents_to_save.progress_bar_value = progress_bar_value
	SaveLoad._save()
	SaveMenu.hide()
	PauseMenu.show()


func _on_no_pressed() -> void:
	SaveMenu.hide()
	PauseMenu.show()


func _on_yes_load_pressed() -> void:
	SaveLoad._load()
	progress_bar_value = SaveLoad.contents_to_save.progress_bar_value
	SaveMenu.hide()
	PauseMenu.show()


func _on_no_load_pressed() -> void:
	SaveMenu.hide()
	PauseMenu.show()
