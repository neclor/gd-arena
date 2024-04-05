extends CharacterBody3D

@export var movement_speed: int = 60
@export var movement_acceleration: int = 5
@export var movement_friction: int = 10

@export var air_movement_scale: int = 1
@onready var camera_component = %CameraComponent
@onready var animation_player = $sugar/AnimationPlayer
@onready var lua_component = $LuaComponent

var behaviour_script: String:
	set(value):
		behaviour_script = value
		if not is_node_ready(): await ready
		lua_component.run(behaviour_script)

@onready var model = $sugar

var direction: Vector3

#TODO перейти на стейт машину
func _process(delta):
	velocity = lerp(velocity, direction * movement_speed, delta * (movement_acceleration if direction else movement_friction))
	move_and_slide()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	animation_player.play("Idle" if not direction else "Run")
	model.rotation.y = lerp(model.rotation.y, model.rotation.y if not direction else position.signed_angle_to(position + direction, Vector3.UP), delta * 8)

func move(direction: Vector3):
	self.direction = direction

func get_direction():
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return Vector3(input.x, 0, input.y)
