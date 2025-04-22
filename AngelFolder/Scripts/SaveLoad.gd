extends Node

const save_location = "user://SaveFile.json"

var contents_to_save: Dictionary = {
	"progess_bar_value": 0.0
}

func _save():
	var file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.WRITE, "92i810hw7")
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open_encrypted_with_pass(save_location, FileAccess.READ, "92i810hw7")
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.progress_bar_value = save_data.progress_bar_value
