class_name LineBox
extends Control

@export var label : RichTextLabel
@export var line = ""
var next_prompt : Button
var character = ""
var finished = false
var timer = 0
var counter = 0

func add_line(new_line):
    self.line += "\n" + new_line
    finished = false
    timer = 0
    next_prompt.visible = false
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
            label.text = "[b]" + character + "[/b]\n"
        else:
            label.text = "[b]" + character + "[/b]\n"
    else:
        label.text = "[i]"

    next_prompt.visible = false

func _process(delta):
    if finished:
        set_process(false)
        next_prompt.visible = true
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
                    timer += 6
                "!":
                    timer += 6
                "?":
                    timer += 6
                ";":
                    timer += 6
                ",":
                    timer += 3
                "—":
                    timer += 4
                " ":
                    timer += 0
                "[":
                    while char != "]":
                        char = line[counter]
                        label.text += char
                        counter += 1
                _:
                    timer += 0.8
        else:
            finished = true
