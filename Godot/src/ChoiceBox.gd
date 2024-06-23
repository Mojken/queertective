class_name ChoiceBox
extends VBoxContainer

var choices : Array = []

@onready var button : Button = $Choice

func _ready():
	for choice in choices:
		var last = get_child(-1)
		if last.text != "":
			last = button.duplicate(DUPLICATE_SIGNALS)
			add_child(last)
		last.pressed.connect(on_pressed)
		last.text = choice

func on_pressed():
	if Rakugo.is_waiting_menu_return():
		for i in range(get_child_count()):
			var button = get_child(i) as Button
			if button != null and button.button_pressed:
				Rakugo.menu_return(i)

	visible = false
