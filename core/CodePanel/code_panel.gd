extends VBoxContainer

@export var base_folder: String = "scripts"
var examples_folder: String = "res://core/CodePanel/examples/"
@onready var scripts_folder_dir = "user://" + base_folder + "/"

@export var scripts_extension: String = ".scr"

@onready var run_scripts_button = %RunScriptsButton
@onready var new_script_window = %NewScriptWindow
@onready var new_script_button = %NewScriptButton
@onready var save_scripts_button = %SaveScriptsButton
@onready var code_edit = %CodeEdit
@onready var delete_script_button = %DeleteScriptButton
@onready var auto_save_check_button = %AutoSaveCheckButton

#TODO заменить на словарь со всеми открытыми скриптами
var current_script: FileAccess

signal new_script_created(path)
signal edit_script_changed()
signal run_pressed(script)

func _ready():
	if not DirAccess.dir_exists_absolute(scripts_folder_dir):
		DirAccess.make_dir_absolute(scripts_folder_dir)
	new_script_button.pressed.connect(new_script_window.popup)
	new_script_created.connect(func(a):
		_update_scripts()
	)
	delete_script_button.pressed.connect(func():
		if current_script:
			delete_script(current_script.get_path_absolute())
	)
	scripts_container.item_selected.connect(func(item):
		if auto_save_check_button.button_pressed:
			save_current_script()
		set_edit_sctipt(scripts_container.get_item_text(item))
	)
	save_scripts_button.pressed.connect(func():
		save_current_script()
	)
	
	edit_script_changed.connect(func():
		if current_script:
			code_edit.clear_undo_history()
			code_edit.editable = true
			code_edit.text = current_script.get_pascal_string()
		else:
			code_edit.editable = false
			code_edit.text = ""
	)
	
	run_scripts_button.pressed.connect( func():
		if current_script:
			run_pressed.emit(current_script.get_path_absolute())
	)
	
	_update_scripts()
	set_edit_sctipt()
	#OS.shell_open(ProjectSettings.globalize_path(scripts_folder_dir))

func _update_scripts():
	scripts_container.clear()
	for file in DirAccess.get_files_at(scripts_folder_dir):
		scripts_container.add_item(file)#file.get_basename())

func new_script(_name: String, example: String = examples_folder + DirAccess.get_files_at(examples_folder)[0]):
	var file = FileAccess.open(scripts_folder_dir + _name, FileAccess.WRITE)
	file.store_pascal_string(FileAccess.get_file_as_string(example))
	file.close()
	new_script_created.emit(scripts_folder_dir + _name)

func delete_script(_path: String):
	if current_script and current_script.get_path_absolute() == _path:
		set_edit_sctipt()
	OS.move_to_trash(_path)
	_update_scripts()

func set_edit_sctipt(_name: String = ""):
	if _name.is_empty():
		current_script = null
	else:
		current_script = FileAccess.open(scripts_folder_dir + _name, FileAccess.READ_WRITE)
	edit_script_changed.emit()

func save_current_script():
	if current_script:
		var _path = current_script.get_path_absolute()
		current_script.close()
		FileAccess.open(_path, FileAccess.WRITE).store_pascal_string(code_edit.text)

func get_examples():
	var examples = DirAccess.get_files_at(examples_folder)
	return examples

@onready var scripts_container = %ScriptsVBoxContainer
