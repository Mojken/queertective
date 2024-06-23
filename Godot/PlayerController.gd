extends CharacterBody3D

@export var speed : float = 2.0

@export var interact_prompt : Button
var interact_target = null

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped : bool = false
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false

var layer_target = null
var layer_start = null
var layer_acc = 0

func _ready():
    Rakugo.parse_and_execute_script("res://dialogue/init.rk")

func _process(_delta):
    if interact_target != null and Input.is_action_just_pressed("interact"):
        if interact_target is Chatable:
            interact_target.chat()

func _physics_process(delta):
    if interact_target != null and interact_target.talking:
        return

    if layer_target != null:
        if layer_start == null:
            layer_start = position.z
        layer_acc += delta * 3
        var smaller = min(abs(layer_start), abs(layer_target))
        var step = smoothstep(
            smaller,
            max(abs(layer_start), abs(layer_target)),
            smaller + layer_acc
        )
        position.z = lerp(layer_start, layer_target, step)

        direction = Vector2.ZERO
        velocity = Vector3.ZERO
        if step >= 1.0:
            layer_target = null
            layer_start = null
            layer_acc = 0
    else:
        direction = Input.get_vector("left", "right", "up", "down")

    if direction.length_squared() > 0:
        velocity = lerp(velocity, Vector3(direction.x, 0, direction.y) * speed, delta * 10)
    else:
        velocity *= 0.5

    # Add the gravity.
    if not is_on_floor():
        velocity.y -= gravity * delta/5
        was_in_air = true
    else:
        was_in_air = false

    move_and_slide()

    var corridor_width = 1.2
    var corridor_spacing = 5
    var mod_pos = fmod(position.z, corridor_spacing)
    if mod_pos < 0:
        mod_pos += 5
    if mod_pos >= corridor_width:
        print(velocity.z)
        if velocity.z > 0:
            layer_target = position.z + corridor_spacing - mod_pos + 0.1
        elif velocity.z < 0:
            layer_target = position.z - mod_pos + corridor_width - 0.1
    #update_animation()
    #update_facing_direction()

func update_animation():
    if not animation_locked:
        if direction.x != 0:
            animated_sprite.play("run")
        else:
            animated_sprite.play("idle")

func update_facing_direction():
    if direction.x > 0:
        animated_sprite.flip_h = false
    elif direction.x < 0:
        animated_sprite.flip_h = true

func _on_animated_sprite_2d_animation_finished():
    if(["jump_end", "jump_start", "jump_double"].has(animated_sprite.animation)):
        animation_locked = false


func _on_area_3d_body_entered(body):
    if body is CharacterBody3D:
        interact_prompt.disabled = false
        interact_target = body as Chatable

func _on_area_3d_body_exited(body):
    if body is CharacterBody3D:
        interact_prompt.disabled = true
        interact_target = null
