extends Node

var lua = LuaAPI.new()


func _bind():
	lua.bind_libraries(["base", "table", "string"])
	lua.push_variant("message", "Hello lua!")
	lua.push_variant("move", get_parent().move)
	lua.push_variant("get_direction", get_parent().get_direction)
	lua.push_variant("print", _print)

	lua.push_variant("get", get_parent().move)


func run(file: String):
	lua = LuaAPI.new()
	_bind()
	var error = lua.do_string(FileAccess.open(file, FileAccess.READ).get_pascal_string())
	#var error = lua.do_string("""
		#function get_message()
			#return "Hello gdScript!"
		#end
	#""")
	if error is LuaError:
		error(error)
		return
	
	var ret = lua.call_function("_ready", [])
	if ret is LuaError:
		error(ret)
		return
	else:
		print(ret)


func _process(delta):
	if lua.function_exists("_update"):
		lua.call_function("_update", [])


func error(err: LuaError):
	print("ERROR %d: %s" % [err.type, err.message])


func _print(a: String):
	print(a)
