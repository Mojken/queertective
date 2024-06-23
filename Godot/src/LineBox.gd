class_name LineBox
extends Control

@export var label : RichTextLabel
@export var before : Control
@export var after : Control
@export var line = ""
var character = ""
var finished = false
var timer = 0
var counter = 0

func add_line(new_line):
	self.line += "\n" + new_line
	finished = false
	timer = 0
	set_process(true)

func rush():
	if counter == 0:
		label.text += line
	else:
		label.text += line.substr(counter)
	counter = len(line)
	finished = true

func _ready():
	if character != null:
		if character == "Me":
			before.visible = true
			label.text = "[right][b]" + character + "[/b]\n"
		else:
			after.visible = true
			label.text = "[b]" + character + "[/b]\n"
	else:
		before.visible = true
		after.visible = true
		label.text = "[center]"

func _process(delta):
	if finished:
		set_process(false)
		return

	if timer > 0:
		timer -= delta * 20

	if timer <= 0:
		if counter < len(line):
			var char = line[counter]
			label.text += char
			counter += 1
			match char:
				".":
					timer += 4
				"!":
					timer += 4
				"?":
					timer += 4
				";":
					timer += 4
				",":
					timer += 2
				"—":
					timer += 2
				" ":
					timer += 0
				_:
					timer += 1
		else:
			finished = true
