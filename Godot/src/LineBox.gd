class_name LineBox
extends Control

@export var label : RichTextLabel
@export var line = ""
var next_prompt : Control
var character = null
var finished = false
var timer = 0
var counter = 0
var sound_timer = 1000
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

func skip(quiet = false):
    if counter == 0:
        label.text += line
    else:
        label.text += line.substr(counter)
    counter = len(line)
    finished = true
    if quiet:
        timer = 0
    else:
        SfxHandler.play_sound_effect(SfxHandler.SOUND_EFFECT.typewriter_bell, 1.0, 1.68)
        timer = 2.43 - 1.68 - 0.1 # end of sound - start of sound - adjustment

func _ready():
    if character != null:
        label.text = "[b]" + character + "[/b]\n"
    else:
        label.text = "[i]"

    if next_prompt:
        next_prompt.visible = false

func _physics_process(delta):
    if finished:
        timer -= min(delta, timer)
        if timer < delta:
            set_physics_process(false)
            if next_prompt:
                next_prompt.visible = true
            sig_finished.emit()
        return

    var speed = Settings.settings.get(Settings.SETTING.text_speed)
    if Settings.settings.get(Settings.SETTING.text_speed) > 40:
        speed = Settings.settings.get(Settings.SETTING.text_speed) / 5

    if timer > 0:
        timer -= delta * speed
        sound_timer += delta * speed
    else:
        var skip_sound = false
        var char = ""
        while timer <= 0:
            if counter < len(line):
                char = line[counter]
                label.text += char
                counter += 1
                match char:
                    ".":
                        timer += 5
                    "!":
                        timer += 5
                    "?":
                        timer += 5
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
                        timer += 1
            if counter >= len(line):
                SfxHandler.play_sound_effect(SfxHandler.SOUND_EFFECT.typewriter_bell, 1.0, 1.5)
                finished = true
                timer = 2.43 - 1.5 - 0.1 # end of sound - start of sound - adjustment
                break

        if !skip_sound and sound_timer >= 0.08 * speed:
            SfxHandler.play_sound_effect([
                SfxHandler.SOUND_EFFECT.type1,
                SfxHandler.SOUND_EFFECT.type2,
                SfxHandler.SOUND_EFFECT.type3,
                SfxHandler.SOUND_EFFECT.type4,
                SfxHandler.SOUND_EFFECT.type5,
                SfxHandler.SOUND_EFFECT.type6
            ][int(char) % 6])
            debug_sound_counter += 1
            sound_timer = 0
