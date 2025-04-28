extends Control

@onready var main_settings = $MainSettings
## @onready var input_settings = $InputSettings ##
@onready var fullscreen_checkbox = $MainSettings/VBoxContainer/FullscreenCheck
@onready var master_volume_slider = $MainSettings/VBoxContainer/HBoxContainer/MasterVolumeSlider
@onready var sfx_volume_slider = $MainSettings/VBoxContainer/HBoxContainer2/SfxVolumeSlider

func _ready():
	var video_settings = ConfigFileHandler.load_video_settings()
	print(video_settings)
	fullscreen_checkbox.button_pressed = video_settings["fullscreen"]
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	master_volume_slider.value = min(audio_settings.master_volume, 1.0) * 100

func _on_keybinding_button_pressed():
	main_settings.visible = false
	## input_settings.visible = true

func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	ConfigFileHandler.save_video_setting("fullscreen", toggled_on)


func _on_master_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("master_volume", master_volume_slider.value / 100)


func _on_sfx_volume_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("sfx_volume", sfx_volume_slider.value / 100)


func _on_button_pressed() -> void:
	get_node("../PanelContainer").show()
	queue_free()
