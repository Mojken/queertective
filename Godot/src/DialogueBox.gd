extends MarginContainer

@export var history_panel : VBoxContainer

var history = []
var last_char = ""
var last_linebox : LineBox = null
@onready var line_box : PackedScene = preload("res://linebox.tscn")

func spawn_line_box(charname, line):
    if charname == last_char:
        last_linebox.add_line(line)
        history[-1] = last_linebox.line
        return
    else:
        last_char = charname

    var box = line_box.instantiate()
    box.line = line
    box.character = charname

    last_linebox = box
    history_panel.add_child(box)
    history.append(line)

func next():
    if !last_linebox.finished:
        last_linebox.rush()
    elif Rakugo.is_waiting_step():
        Rakugo.do_step()
    elif Rakugo.is_waiting_menu_return():
        Rakugo.menu_return(0)

func _ready():
    visible = false
    Rakugo.sg_say.connect(_on_say)
    Rakugo.sg_menu.connect(_on_menu)
    Rakugo.sg_execute_script_start.connect(_on_execute_script_start)
    Rakugo.sg_execute_script_finished.connect(_on_execute_script_finished)

func _on_say(character:Dictionary, line:String):
    var charname = character.get("name", null)
    spawn_line_box(charname, line)

func _on_menu(choices:Array):
    var text = ""
    for choice in choices:
        text += "- " + choice + "\n"
    text[-1] = ""
    spawn_line_box("Choice", text)

func _on_execute_script_start(_script_name:String):
    visible = true
    grab_focus()

func _on_execute_script_finished(_script_name:String, _error_str:String):
    visible = false
    release_focus()

func _gui_input(event):
    if event is InputEventMouseButton:
        if event.button_index == 1 and event.pressed:
            next()
    elif event is InputEventKey:
        if event.is_action("interact"):
            next()
