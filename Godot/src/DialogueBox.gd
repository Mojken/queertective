extends MarginContainer

@export var history_panel : VBoxContainer

var history = []
var last_char = ""
var last_linebox : LineBox = null
@onready var line_box : PackedScene = preload("res://linebox.tscn")
@onready var choice_box : PackedScene = preload("res://choice_box.tscn")

func spawn_line_box(charname, line):
    if charname == last_char:
        last_linebox.add_line(line)
        history[-1] = last_linebox.line
        return last_linebox
    elif charname != null:
        last_char = charname

    var box = line_box.instantiate()
    box.line = line
    box.character = charname

    last_linebox = box
    history_panel.add_child(box)
    if charname == null:
        box.rush()
    history.append(line)
    return box

func next():
    if !last_linebox.finished:
        last_linebox.rush()
    elif Rakugo.is_waiting_step():
        Rakugo.do_step()

func _ready():
    visible = false
    Rakugo.sg_say.connect(_on_say)
    Rakugo.sg_menu.connect(_on_menu)
    Rakugo.sg_variable_changed.connect(_on_var_changed)
    Rakugo.sg_character_variable_changed.connect(_on_charvar_changed)
    Rakugo.sg_execute_script_start.connect(_on_execute_script_start)
    Rakugo.sg_execute_script_finished.connect(_on_execute_script_finished)

func _on_say(character:Dictionary, line:String):
    grab_focus()
    var charname = character.get("name", null)
    spawn_line_box(charname, line)

func _on_menu(choices:Array):
    var box = choice_box.instantiate()
    box.choices = choices
    history_panel.add_child(box)

func _on_execute_script_start(_script_name:String):
    visible = true

func _on_execute_script_finished(_script_name:String, _error_str:String):
    visible = false
    release_focus()
    for child in history_panel.get_children():
        history_panel.remove_child(child)

func _on_charvar_changed(character_tag:String, var_name:String, value:Variant):
    if character_tag == "clues":
        spawn_line_box(null, "Clue found!")
    else:
        match var_name:
            "appointments":
                spawn_line_box(null, "You've scheduled a new appointment")

    if len(character_tag) > 0:
        character_tag += "."
    print(character_tag, var_name, " changed to ", value)

func _on_var_changed(var_name:String, value:Variant):
    _on_charvar_changed("", var_name, value)

func _gui_input(event):
    if event is InputEventMouseButton:
        if event.button_index == 1 and event.pressed:
            next()
    elif event is InputEventKey:
        if event.is_action("interact") and event.pressed and not event.echo:
            next()
