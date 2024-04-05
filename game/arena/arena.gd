extends Node3D


const CHARACTER = preload("res://game/Character/character.tscn")


@onready var spawn_point = $SpawnPoint
@onready var characters_container = $CharactersContainer


func create_new_character(new_script : String):
	var new_character = CHARACTER.instantiate()
	new_character.position = spawn_point.position
	new_character.behaviour_script = new_script
	characters_container.add_child(new_character)
