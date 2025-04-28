extends Control

@onready var MainMenu = $MainMenu
@onready var SettingMenu = $Settings

@onready var MusicPlayer = %Music
@onready var FocusPlayer = $Focus
@onready var ButtonPlayer = $ButtonPress

const MUSIC_BUS = "Music"
const FX_BUS = "FX"

var volume = -80

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func FocusEntered():
	FocusPlayer.play()

func _on_play_pressed() -> void:
	ButtonPlayer.play()
	get_tree().change_scene_to_file("res://scenes/dungeonLevelScene.tscn")


func _on_settings_pressed() -> void:
	ButtonPlayer.play()
	MainMenu.hide()
	SettingMenu.show()


func _on_quit_pressed() -> void:
	ButtonPlayer.play()
	get_tree().quit()


func _on_master_slider_value_changed(value: float) -> void:
	if value == 45:
		AudioServer.set_bus_mute(0,true)
	else:
		AudioServer.set_bus_mute(0,false)
		AudioServer.set_bus_volume_db(0,value)

func _on_button_pressed() -> void:
	ButtonPlayer.play()
	MainMenu.show()
	SettingMenu.hide()


func _on_music_slider_value_changed(value: float) -> void:
	var BusInt = AudioServer.get_bus_index(MUSIC_BUS)
	AudioServer.set_bus_volume_db(BusInt, value)


func _on_fx_slider_value_changed(value: float) -> void:
	var BusInt = AudioServer.get_bus_index(FX_BUS)
	AudioServer.set_bus_volume_db(BusInt, value)

#func _on_brightness_slider_value_changed(value: float) -> void:
	#GlobalWorldEnvironment.environment.adjustment_brightness = value
