class_name Chatable
extends CharacterBody3D

@export var character_name : String = ""
@onready var marker : Vector3 = $Marker.position
var talking : bool = false
var talk_delay : float = 0

func chat():
    print(talk_delay)
    if not talking and talk_delay == 0:
        Rakugo.parse_and_execute_script("res://dialogue/" + character_name + ".rk")
        Rakugo.sg_execute_script_finished.connect(_on_execute_script_finished)
        talking = true
        Rakugo.sg_say.connect(_on_say)
        return true
    return false

func _on_say(_character:Dictionary, _text:String):
    #TODO: Handle playing talk animation
    pass

func _on_execute_script_finished(script_name:String, _error_str:String):
    if character_name in script_name:
        talking = false
        Rakugo.sg_execute_script_finished.disconnect(_on_execute_script_finished)
        Rakugo.sg_say.disconnect(_on_say)
        talk_delay = 2.0

func _process(delta):
    if talk_delay > 0:
        talk_delay -= min(delta, talk_delay)
