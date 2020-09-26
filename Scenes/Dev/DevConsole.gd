extends Control

onready var input := $Input
var input_storage = null
onready var output := $Output
onready var command_manager := $CommandManager

var history = []
var history_reverse_stack = []

var close_dist = 255

var closed = true setget close

func close(b):
	closed = b
	$Tween.interpolate_property(get_parent(),"position",get_parent().position,Vector2(0,close_dist if b else 0.0),0.3,Tween.TRANS_EXPO,Tween.EASE_OUT)
	$Tween.start()
	if closed:
		input_storage = input
		remove_child(input)
	else:
		add_child(input)


func _ready():
	input.grab_focus()
	close(true)

func _input(event):
	if event.is_echo(): return
	if Input.is_action_just_pressed("console"):
		close(not closed)
	
	if closed: return
		
	if Input.is_key_pressed(KEY_DOWN):
		if history_reverse_stack.empty():
			return
		var t = history_reverse_stack.pop_back()
		input.text = t
		history.append(t)
		accept_event()
	elif Input.is_key_pressed(KEY_UP):
		if history.empty():
			return
		var t = history.pop_back()
		input.text = t
		history_reverse_stack.append(t)
		accept_event()
	elif Input.is_key_pressed(KEY_TAB) and input.text != "":
		var closest_match = 0.0
		var closest_command = input.text
		for command in command_manager.commands:
			var similarity = input.text.similarity(command[0])
			if similarity > closest_match:
				closest_command = command[0]
				closest_match = similarity
		input.text = closest_command
		input.caret_position = (input.text.length())
		accept_event()

func process_command(text: String) -> void:
	var tokens := text.split(" ") as Array
	for _i in range(0, tokens.count("")):
		tokens.erase("")
		
	if tokens.size() == 0:
		return
		
	var cmd = tokens.pop_front()
	for c in command_manager.commands:
		if c[0] == cmd:
			if tokens.size() != c[1].size():
				if cmd == "help":
					command_manager.callv(cmd, [""])
					return
				output_text("Invalid Command: %s, expected %d parameters" % [cmd, c[1].size()])
				return
			for i in range(tokens.size()):
				if not check_type(tokens[i], c[1][i]):
					output_text("Invalid Command: %s, parameter %d, %s is not the right type" % [cmd, i + 1, tokens[i]]) 
					return
			command_manager.callv(cmd, tokens)
			return
	output_text("Invalid Command: %s, Command not found" % [cmd])


func check_type(string: String, type):
	match type:
		command_manager.ARG_INT:
			return string.is_valid_integer()
		command_manager.ARG_FLOAT:
			return string.is_valid_float()
		command_manager.ARG_STRING:
			return true
		command_manager.ARG_BOOL:
			return (string == "true" or string == "false)")
		_:
			return false

func output_text(text: String):
	output.text = "%s\n%s" % [output.text, text]

func _on_Input_text_entered(new_text):
	if closed:
		return
	input.clear()
	output_text(new_text)
	process_command(new_text)
	history.append(new_text)
	history_reverse_stack = []
