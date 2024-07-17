class_name LineBox
extends Control

@export var label : RichTextLabel
@export var line = ""
var next_prompt : Control
var character = null
var finished = false
var timer = 0
var counter = 0
var sound_timer = 0
var debug_sound_counter = 0

signal sig_finished

func add_line(new_line):
    self.line += "\n\n" + new_line
    finished = false
    timer = 0
    next_prompt.visible = false
    set_physics_process(true)

func rush():
    timer -= 25

func full_rush():
    if counter == 0:
        label.text += line
    else:
        label.text += line.substr(counter)
    counter = len(line)
    finished = true

func _ready():
    if character != null:
        label.text = "[b]" + character + "[/b]\n"
    else:
        label.text = "[i]"

    if next_prompt:
        next_prompt.visible = false

func _physics_process(delta):
    if finished:
        set_physics_process(false)
        if next_prompt:
            next_prompt.visible = true
        sig_finished.emit()
        return

    if timer > 0:
        if Settings.settings.get(Settings.SETTING.text_speed) <= 40:
            timer -= delta * Settings.settings.get(Settings.SETTING.text_speed)
        else:
            timer -= delta * Settings.settings.get(Settings.SETTING.text_speed) / 5
    if sound_timer > 0:
        sound_timer -= delta

    while timer <= 0:
        if counter < len(line):
            var char = line[counter]
            label.text += char
            counter += 1
            var skip_sound = false
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
                "\n":
                    timer += 0
                " ":
                    timer += 1.5
                    sound_timer = 0
                    if Settings.settings.get(Settings.SETTING.text_speed) <= 40:
                        skip_sound = true
                "[":
                    while char != "]":
                        char = line[counter]
                        label.text += char
                        counter += 1
                _:
                    if Settings.settings.get(Settings.SETTING.text_speed) > 40:
                        continue
                    timer += 0.8
            if timer > 0 and !skip_sound:
                sound_timer -= 1
                if sound_timer <= 0:
                    SfxHandler.play_sound_effect([SfxHandler.SOUND_EFFECT.type1, SfxHandler.SOUND_EFFECT.type2, SfxHandler.SOUND_EFFECT.type3, SfxHandler.SOUND_EFFECT.type4, SfxHandler.SOUND_EFFECT.type5, SfxHandler.SOUND_EFFECT.type6][int(char) % 6])
                    debug_sound_counter += 1
                    sound_timer = 2
        else:
            finished = true
            break
