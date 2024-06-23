extends Sprite3D

# This script makes the npcs look in the direction of the player.
# Ptobably a cleaner way to do this but it's a proof of concept start.

var scale_x

func _ready():
	scale_x = scale.x


func _physics_process(delta):
	if GloballyAccessibleNodes.player.global_position.x > global_position.x:
		scale.x = -scale_x
	else:
		scale.x = scale_x
