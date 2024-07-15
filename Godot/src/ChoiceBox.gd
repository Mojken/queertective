class_name ChoiceBox
extends VBoxContainer

var choices : Array = []

@onready var button : Button = $Choice
@onready var next_prompt : Button = $NextPrompt

func set_choices(new_choices):
    next_prompt.visible = false
    for choice in new_choices.size():
        var last = button.duplicate(DUPLICATE_SIGNALS)
        add_child(last)
        choices.append(last)
        last.pressed.connect(on_pressed)
        last.text = str(choice + 1) + " - \"" + new_choices[choice] + "\""
        last.visible = true

func on_pressed():
    if Rakugo.is_waiting_menu_return():
        for i in range(get_child_count()):
            var button = get_child(i) as Button
            if button != null and button.button_pressed:
                Rakugo.menu_return(i-2)

    for child in choices:
        remove_child(child)
    choices = []
