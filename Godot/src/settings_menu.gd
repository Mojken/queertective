extends Control

signal sig_closed

@export var linebox : LineBox
@export var volume_slider : HSlider
@export var SFXvolume_slider : HSlider
@export var size_slider : HSlider
@export var speed_slider : HSlider
@export var close_button : Button

func _ready():
    volume_slider.value_changed.connect(volume_changed)
    volume_changed(volume_slider.value)
    SFXvolume_slider.value_changed.connect(SFXvolume_changed)
    SFXvolume_changed(SFXvolume_slider.value)
    speed_slider.value_changed.connect(speed_changed)
    speed_changed(speed_slider.value)
    size_slider.value_changed.connect(size_changed)
    size_changed(size_slider.value)

    close_button.pressed.connect(close)

    linebox.sig_finished.connect(repeat_text)
    close()

func volume_changed(new_value):
    Settings.settings[Settings.SETTING.volume] = new_value
    MusicHandler.set_volume(new_value)

func SFXvolume_changed(new_value):
    Settings.settings[Settings.SETTING.volume] = new_value
    SfxHandler.set_volume(new_value)

func speed_changed(new_value):
    Settings.settings[Settings.SETTING.text_speed] = new_value

func size_changed(new_value):
    Settings.settings[Settings.SETTING.font_size] = new_value
    self.theme.default_font_size = new_value
    self.theme.set_font_size("bold_font_size", "DialogueLabel", new_value * 1.1)
    self.theme.set_font_size("normal_font_size", "DialogueLabel", new_value)
    self.theme.set_font_size("italics_font_size", "DialogueLabel", new_value)

func close():
    visible = false
    linebox.set_physics_process(false)
    sig_closed.emit()

func open():
    visible = true
    linebox.set_physics_process(true)
    repeat_text()

func repeat_text():
    linebox.debug_sound_counter = 0
    linebox.label.text = "[b]Example:[/b]\n"
    linebox.line = "The quick brown fox jumps over the lazy dog. Sphinx of black quartz, judge my vow!"
    linebox.finished = false
    linebox.timer = 0
    linebox.counter = 0
    linebox.set_physics_process(true)
