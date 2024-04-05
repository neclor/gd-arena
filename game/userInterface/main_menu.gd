extends CanvasLayer

@onready var start_button = %StartButton
@onready var settings_button = %SettingsButton
@onready var exit_button = %ExitButton
@onready var arena_button = %ArenaButton

@onready var settings = %Settings

@export var started_scene: String

func _ready():
	var start = func():
		get_tree().get_root().add_child(preload("res://game/userInterface/user_interface.tscn").instantiate())
		get_tree().change_scene_to_file(started_scene)

	start_button.pressed.connect(start)
	var settings = func():
		self.settings.visible = !self.settings.visible
	settings_button.pressed.connect(settings)
	exit_button.pressed.connect(get_tree().quit)

	var arena = func():
		get_tree().change_scene_to_file("res://game/main/test_arena_main/test_arena.tscn")
	arena_button.pressed.connect(arena)

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		settings.visible = false
