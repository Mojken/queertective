class_name Chatable
extends CharacterBody3D

@export var character_name : String = ""
var talked = false

func chat():
    if not talked:
        Rakugo.parse_and_execute_script("res://dialogue/" + character_name + ".rk")
        talked = true
        Rakugo.sg_say.connect(_on_say)


func _on_say(_character:Dictionary, _text:String):
    pass
    #TODO: Handle playing talk sound, animation
