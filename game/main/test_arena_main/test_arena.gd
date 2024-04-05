extends Node


@onready var code_panel = $GameMenu/%CodePanel
@onready var arena = $SubViewport/Arena



func _ready():
	code_panel.run_pressed.connect(add_script)


func add_script(script: String):
	arena.create_new_character(script)
