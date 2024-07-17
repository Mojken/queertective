extends MarginContainer

@export var history_panel : VBoxContainer
@export var scroll_container : ScrollContainer
@export var choice_box : ChoiceBox

var history = []
var last_char = ""
var last_linebox : LineBox = null
@onready var line_box : PackedScene = preload("res://linebox.tscn")

func spawn_line_box(charname, line):
    if last_char != null and charname == last_char:
        last_linebox.add_line(line)
        history[-1] = last_linebox.line
        return last_linebox
    #last_char = charname

    var box = line_box.instantiate()
    box.line = line
    box.character = charname
    box.next_prompt = choice_box.next_prompt

    last_linebox = box
    history_panel.add_child(box)
    #if charname == null:
    #    box.rush()

    history.append(line)
    return box

func next():
    if last_linebox and !last_linebox.finished:
        last_linebox.rush()
    elif Rakugo.is_waiting_step():
        last_linebox.set_physics_process(false)
        Rakugo.do_step()

func auto_scroll():
    var bar = scroll_container.get_v_scroll_bar()
    bar.value = bar.max_value

func _ready():
    visible = false
    Rakugo.sg_execute_script_start.connect(_on_execute_script_start)
    Rakugo.sg_say.connect(_on_say)
    Rakugo.sg_menu.connect(_on_menu)
    Rakugo.sg_variable_changed.connect(_on_var_changed)
    Rakugo.sg_execute_script_finished.connect(_on_execute_script_finished)
    scroll_container.get_v_scroll_bar().changed.connect(auto_scroll)

func _on_say(character:Dictionary, line:String):
    grab_focus()
    var charname = character.get("name", null)
    spawn_line_box(charname, line)

func _on_menu(choices:Array):
    choice_box.set_choices(choices)

func _on_execute_script_start(_script_name:String):
    visible = true

func _on_execute_script_finished(_script_name:String, _error_str:String):
    visible = false
    release_focus()
    for child in history_panel.get_children():
        history_panel.remove_child(child)
    last_char = ""
    last_linebox = null

func _on_charvar_changed(character_tag:String, var_name:String, value:Variant):
    if character_tag == "clues":
        spawn_line_box(null, "───── Clue found! ─────")
        SfxHandler.play_sound_effect(SfxHandler.SOUND_EFFECT.eureka)
    else:
        match var_name:
            "appointments":
                spawn_line_box(null, "You've scheduled a new appointment")

    if len(character_tag) > 0:
        character_tag += "."

func _on_var_changed(var_name:String, value:Variant):
    _on_charvar_changed("", var_name, value)

var skip_timer = -1
func _process(delta):
    if skip_timer >= 0 and Input.is_action_pressed("interact"):
        skip_timer += delta
    if skip_timer > 0.5:
        if last_linebox and !last_linebox.finished:
            last_linebox.skip()
        else:
            next()
        skip_timer = -1

func _gui_input(event):
    if event.is_action("interact"):
        if event.pressed:
            skip_timer = 0
        elif skip_timer > 0 and skip_timer < 0.5:
            next()
            skip_timer = -1

