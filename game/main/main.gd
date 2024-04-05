extends Node

@onready var code_panel = $GameMenu/%CodePanel
@onready var character = %Character


func _ready():
	code_panel.run_pressed.connect(func(script: String):
		character.behaviour_script = script
	)

