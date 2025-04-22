extends Node

@onready var input_button_scene = preload("res://AngelFolder/Scenes/input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"move_forward": "Move forward",
	"move_left": "Move left",
	"move_backward": "Move backward",
	"move_right": "Move right",
	"attack": "Attack",
	"range_attack": "Range attack",
	"interact": "Interact"
}

func _ready():
	_load_keybindings_from_settings()
	_create_action_list()

func _load_keybindings_from_settings():
	var keybindings = ConfigFileHandler.load_keybindings()
	for action in keybindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybindings[action])

func _create_action_list():
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_Label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_Label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."

func _input(event):
	if is_remapping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			# Turn double click into single click
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_add_event(action_to_remap, event)
		
			#Remove duplicate inputs from previous assigned actions
			for action in input_actions:
				if InputMap.action_has_event(action, event):
					InputMap.action_erase_event(action, event)
					var button_with_action = action_list.get_children().filter(func(button):
						return button.find_child("LabelAction").text == input_actions[action]
					)
					for button in button_with_action:
						button.find_child("LabelInput").text = ""
				
			ConfigFileHandler.save_keybinding(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			

func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_button_pressed() -> void:
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if event.size() > 0:
			ConfigFileHandler.save_keybinding(action, events[0])
	_create_action_list()
