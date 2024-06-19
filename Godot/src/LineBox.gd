class_name LineBox
extends TextEdit

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
    text += line.substr(counter)
    counter = len(line)
    finished = true

func _ready():
    if character != null:
        text = character + "\n"

func _process(delta):
    if finished:
        set_process(false)
        return

    if timer > 0:
        timer -= delta * 20

    if timer <= 0:
        var char = line[counter]
        text += char
        counter += 1

        if counter < len(line):
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
