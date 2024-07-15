extends Control

var main_scene = preload("res://world_scene.tscn")

func _ready():
    if main_scene == null:
        push_error("Failed to load main scene")
    Rakugo.parse_and_execute_script("res://dialogue/init.rk")
    await get_tree().process_frame
    Rakugo.parse_and_execute_script("res://dialogue/introduction.rk")
    Rakugo.sg_execute_script_finished.connect(start_game)

func start_game(_scene, _err):
    get_tree().change_scene_to_packed(main_scene)
